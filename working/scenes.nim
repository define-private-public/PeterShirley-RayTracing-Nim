# This file contains scenes that are used

import vec3
import hitable_and_material
import hitable_list
import sphere, moving_sphere
import lambertian, metal, dielectric
import util
import bvh_node
import texture, constant_texture, checker_texture, noise_texture


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

