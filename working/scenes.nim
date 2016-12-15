# This file contains scenes that are used, as well as their camera positionings

import vec3
import hitable_and_material
import hitable_list
import sphere, moving_sphere, rects, flip_normals, box, translate, rotate_y, constant_medium
import lambertian, metal, dielectric, diffuse_light
import util
import bvh_node
import texture, constant_texture, checker_texture, noise_texture, image_texture
import stb_image
import camera


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

#  list.add(newBox(newVec3(130, 0, 65), newVec3(295, 165, 230), white))
#  list.add(newBox(newVec3(265, 0, 295), newVec3(430, 330, 460), white))

  list.add(newTranslate(newRotateY(newBox(newVec3(0, 0, 0), newVec3(165, 165, 165), white), -18), newVec3(130,0,65)))
  list.add(newTranslate(newRotateY(newBox(newVec3(0, 0, 0), newVec3(165, 330, 165), white),  15), newVec3(265,0,295)))

  return newHitableList(list)


proc cornell_smoke*(): hitable =
  var list: seq[hitable] = @[]
  let
    red = newLambertian(newConstantTexture(newVec3(0.65, 0.05, 0.05)))
    white = newLambertian(newConstantTexture(newVec3(0.73, 0.73, 0.73)))
    green = newLambertian(newConstantTexture(newVec3(0.12, 0.45, 0.15)))
    light = newDiffuseLight(newConstantTexture(newVec3(7, 7, 7)))

  list.add(newFlipNormals(newYZRect(0, 555, 0, 555, 555, green)))
  list.add(newYZRect(0, 555, 0, 555, 0, red))
  list.add(newXZRect(113, 443, 127, 432, 554, light))
  list.add(newFlipNormals(newXZRect(0, 555, 0, 555, 555, white)))
  list.add(newXZRect(0, 555, 0, 555, 0, white))
  list.add(newFlipNormals(newXYRect(0, 555, 0, 555, 555, white)))

  # TODO when the transform issue is fixed, come back and renable rotations
  let
   b1 = newTranslate(newBox(newVec3(0, 0, 0), newVec3(165, 165, 165), white), newVec3(130,0,65))
   b2 = newTranslate(newBox(newVec3(0, 0, 0), newVec3(165, 330, 165), white), newVec3(265,0,295))
#   b1 = newTranslate(newRotateY(newBox(newVec3(0, 0, 0), newVec3(165, 165, 165), white), -18), newVec3(130,0,65))
#   b2 = newTranslate(newRotateY(newBox(newVec3(0, 0, 0), newVec3(165, 330, 165), white),  15), newVec3(265,0,295))

  list.add(newConstantMedium(b1, 0.01, newConstantTexture(newVec3(1, 1, 1))))
  list.add(newConstantMedium(b2, 0.01, newConstantTexture(newVec3(0, 0, 0))))

  return newHitableList(list)


proc final*(): hitable =
  let nb = 20
  var
    list: seq[hitable] = @[]
    boxlist : seq[hitable] = @[]
    boxlist2 : seq[hitable] = @[]
  let
    white = newLambertian(newConstantTexture(newVec3(0.73, 0.73, 0.73)))
    ground = newLambertian(newConstantTexture(newVec3(0.48, 0.83, 0.53)))

  for i in countup(0, nb - 1):
    for j in countup(0, nb - 1):
      let
        w = 100.0
        x0 = -1000 + (i.float * w)
        z0 = -1000 + (j.float * w)
        y0 = 0.0
        x1 = x0 + w
        y1 = 100 * (drand48() + 0.01)
        z1 = z0 + 2

      boxlist.add(newBox(newVec3(x0, y0, z0), newVec3(x1, y1, z1), ground))

  list.add(newBVHNode(boxlist, 0, 1))

  let light = newDiffuseLight(newConstantTexture(newVec3(7, 7, 7)))
  list.add(newXZRect(123, 423, 147, 412, 554, light))

  let center = newVec3(400, 400, 200)
  list.add(newMovingSphere(center, center + newVec3(30, 0, 0), 0, 1, 50, newLambertian(newConstantTexture(newVec3(0.7, 0.3, 0.1)))))

  list.add(newSphere(newVec3(260, 150, 45), 50, newDielectric(1.5)))
  list.add(newSphere(newVec3(0, 150, 145), 50, newMetal(newVec3(0.8, 0.8, 0.9), 10)))
  
  var boundary = newSphere(newVec3(360, 150, 145), 70, newDielectric(1.5))
  list.add(boundary)
  list.add(newConstantMedium(boundary, 0.2, newConstantTexture(newVec3(0.2, 0.4, 0.9))))

  boundary = newSphere(newVec3(0, 0, 0), 5000, newDielectric(1.5))
  list.add(newConstantMedium(boundary, 0.0001, newConstantTexture(newVec3(1, 1, 1))))

  var
    nx, ny, nn: int
    tex_data = stbi_load("earthmap.jpg", nx, ny, nn, 0)
  let emat = newLambertian(newImageTexture(tex_data, nx, ny))
  list.add(newSphere(newVec3(400, 200, 400), 100, emat))

  let pertext = newNoiseTexture(0.1)
  list.add(newSphere(newVec3(220, 280, 300), 80, newLambertian(pertext)))

  let ns = 1000
  for j in countup(0, ns - 1):
    boxlist2.add(newSphere(newVec3(165 * drand48(), 165 * drand48(), 165 * drand48()), 10, white))
  list.add(newTranslate(newRotateY(newBVHNode(boxlist2, 0, 1), 15), newVec3(-100, 270, 395)))

  return newHitableList(list)




# ===================
# Camera Positionings
# ===================

proc original_scene_cam*(renderWidth, renderHeight: int): camera =
  let  
    lookfrom = newVec3(3, 3, 2)
    lookat = newVec3(0, 0, -1)
    dist_to_focus = (lookfrom - lookat).length()
    aperature = 2.0

  return newCamera(
    lookfrom,
    lookat,
    newVec3(0, 1, 0),
    20,
    renderWidth.float / renderHeight.float,
    aperature,
    dist_to_focus,
    0, 1
  )


proc random_scene_cam*(renderWidth, renderHeight: int): camera =
  let
    lookfrom = newVec3(13, 2, 3)
    lookat = newVec3(0, 0, 0)
    dist_to_focus = 10.0
    aperature = 0.0

  return newCamera(
    lookfrom,
    lookat,
    newVec3(0, 1, 0),
    20,
    renderWidth.float / renderHeight.float,
    aperature,
    dist_to_focus,
    0, 1
  )


proc two_spheres_cam*(renderWidth, renderHeight: int): camera =
  return random_scene_cam(renderWidth, renderHeight)


proc two_perlin_spheres_cam*(renderWidth, renderHeight: int): camera =
  return random_scene_cam(renderWidth, renderHeight)


proc earth_cam*(renderWidth, renderHeight: int): camera =
  return random_scene_cam(renderWidth, renderHeight)


proc simple_light_cam*(renderWidth, renderHeight: int): camera =
  let
    lookfrom = newVec3(30, 5, 25)
    lookat = newVec3(0, 0, 0)
    dist_to_focus = 10.0
    aperature = 0.0

  return newCamera(
    lookfrom,
    lookat,
    newVec3(0, 1, 0),
    20,
    renderWidth.float / renderHeight.float,
    aperature,
    dist_to_focus,
    0, 1
  )


proc cornell_box_cam*(renderWidth, renderHeight: int): camera =
  let
    lookfrom = newVec3(278, 278, -800)
    lookat = newVec3(278, 278, 0)
    dist_to_focus = 10.0
    aperature = 0.0
    vfov = 40.0

  return newCamera(
    lookfrom,
    lookat,
    newVec3(0, 1, 0),
    vfov,
    renderWidth.float / renderHeight.float,
    aperature,
    dist_to_focus,
    0, 1
  )


proc cornell_smoke_cam*(renderWidth, renderHeight: int): camera =
  return cornell_box_cam(renderWidth, renderHeight)
