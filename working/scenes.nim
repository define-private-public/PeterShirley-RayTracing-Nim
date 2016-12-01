# This file contains scenes that are used

import vec3
import hitable_and_material
import hitable_list
import sphere, moving_sphere, flip_normals
import rects
import lambertian, metal, dielectric, diffuse_light
import util
import bvh_node
import texture, constant_texture, checker_texture, noise_texture, image_texture
import stb_image


# This is the first "real," scene that is made in he book
proc original_scene*(): hitable =
  var list: seq[hitable] = @[]
  list.add(newSphere(newVec3(0, 0, -1), 0.5, newLambertian(newConstantTexture(newVec3(0.1, 0.2, 0.5)))))
  list.add(newSphere(newVec3(0, -100.5, -1), 100, newLambertian(newConstantTexture(newVec3(0.8, 0.8, 0)))))
  list.add(newSphere(newVec3(1, 0, -1), 0.5, newMetal(newVec3(0.8, 0.6, 0.2), 1)))
  list.add(newSphere(newVec3(-1, 0, -1), 0.5, newDielectric(1.5)))
  list.add(newSphere(newVec3(-1, 0, -1), -0.45, newDielectric(1.5)))

  return newHitableList(list)


proc random_scene*(): hitable=
  # TODO in the ch1. book source, it says to use 50,000, but I think that's a little too much right now...
  let n = 500

  var list: seq[hitable] = @[]

  let checker: texture = newCheckerTexture(newConstantTexture(newVec3(0.2, 0.3, 0.1)),
                                           newConstantTexture(newVec3(0.9, 0.9, 0.8)))
  list.add(newSphere(newVec3(0, -1000, 0), 1000, newLambertian(checker)))

  var i = 1
  for a in countup(-10, 9):
    for b in countup(-10, 9):
      let
        choose_mat = drand48()
        center = newVec3(a.float + (0.9 * drand48()), 0.2, b.float + (0.9 * drand48()))

      if (center - newVec3(4, 0.2, 0)).length() > 0.9:
        if choose_mat < 0.8:
          # diffuse
          list.add(newMovingSphere(center, center + newVec3(0, 0.5 * drand48(), 0), 0, 1, 0.2,
                                   newLambertian(newConstantTexture(newVec3(drand48() * drand48(),
                                                                            drand48() * drand48(),
                                                                            drand48() * drand48())))))
                                   
        elif choose_mat < 0.95:
          # metal
          list.add(newSphere(center, 0.2, newMetal(newVec3(0.5 * (1 + drand48()),
                                                           0.5 * (1 + drand48()),
                                                           0.5 * (1 + drand48())),
                                                           0.5 * drand48())))
        else:
          # glass
          list.add(newSphere(center, 0.2, newDielectric(1.5)))

  list.add(newSphere(newVec3(0, 1, 0), 1, newDielectric(1.5)))
  list.add(newSphere(newVec3(-4, 1, 0), 1, newLambertian(newConstantTexture(newVec3(0.4, 0.2, 0.1)))))
  list.add(newSphere(newVec3(4, 1, 0), 1, newMetal(newVec3(0.7, 0.6, 0.5), 0)))
 
#  return newBVHNode(list, 0, 1)
  return newHitableList(list)


proc two_spheres*(): hitable =
  let checker: texture = newCheckerTexture(newConstantTexture(newVec3(0.2, 0.3, 0.1)),
                                           newConstantTexture(newVec3(0.9, 0.9, 0.8)))
  var list: seq[hitable] = @[]
  list.add(newSphere(newVec3(0, -10, 0), 10, newLambertian(checker)))
  list.add(newSphere(newVec3(0, 10, 0), 10, newLambertian(checker)))

  return newHitableList(list)


proc two_perlin_spheres*(): hitable =
  let pertext = newNoiseTexture()
  var list: seq[hitable] = @[]
  list.add(newSphere(newVec3(0, -1000, 0), 1000, newLambertian(pertext)))
  list.add(newSphere(newVec3(0, 2, 0), 2, newLambertian(pertext)))

  return newHitableList(list)


proc earth*(): hitable =
  var
    width: int
    height: int
    comp: int
    tex_data = stbi_load("earthmap.jpg", width, height, comp, 0)

  return newSphere(newVec3(0, 0, 0), 2, newLambertian(newImageTexture(tex_data, width, height)))


proc simple_light*(): hitable =
  let pertext = newNoiseTexture()
  var list: seq[hitable] = @[]
  list.add(newSphere(newVec3(0, -1000, 0), 1000, newLambertian(pertext)))
  list.add(newSphere(newVec3(0, 2, 0), 2, newLambertian(pertext)))
  list.add(newSphere(newVec3(0, 7, 0), 2, newDiffuseLight(newConstantTexture(newVec3(4, 4, 4)))))
  list.add(newXYRect(3, 5, 1, 3, -2, newDiffuseLight(newConstantTexture(newVec3(4, 4, 4)))))

  return newHitableList(list)


proc cornell_box*(): hitable =
  var list: seq[hitable] = @[]
  let
    red = newLambertian(newConstantTexture(newVec3(0.65, 0.05, 0.05)))
    white = newLambertian(newConstantTexture(newVec3(0.73, 0.73, 0.73)))
    green = newLambertian(newConstantTexture(newVec3(0.12, 0.45, 0.15)))
    light = newDiffuseLight(newConstantTexture(newVec3(15, 15, 15)))

  list.add(newFlipNormals(newYZRect(0, 555, 0, 555, 555, green)))
  list.add(newYZRect(0, 555, 0, 555, 0, red))
  list.add(newXZRect(213, 343, 227, 332, 554, light))
  list.add(newFlipNormals(newXZRect(0, 555, 0, 555, 555, white)))
  list.add(newXZRect(0, 555, 0, 555, 0, white))
  list.add(newFlipNormals(newXYRect(0, 555, 0, 555, 555, white)))

  return newHitableList(list)

