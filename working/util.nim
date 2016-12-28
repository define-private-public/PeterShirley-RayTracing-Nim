# This is a collection of the extra functions that are used around the program

import math
import random
import vec3


randomize()


# Produced a random number between [0, 1)
proc drand48*(): float=
  return random(1.0)


proc random_in_unit_sphere*(): vec3=
  var p = newVec3()

  # Note: Nim doesn't have built-in do-while loops, so we do this intead
  p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)
  while p.dot(p) > 1:
    p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)

  return p


proc random_on_unit_sphere*(): vec3 =
  var p = newVec3()

  # Note: Nim doesn't have built-in do-while loops, so we do this intead
  p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)
  while p.dot(p) > 1:
    p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)

  return unit_vector(p)


proc schlick*(cosine, ref_idx: float): float=
  var r0 = (1 - ref_idx) / (1 + ref_idx)
  r0 = r0 * r0
  return r0 + ((1 - r0) * pow(1 - cosine, 5))


proc random_cosine_direction*(): vec3 =
  let
    r1 = drand48()
    r2 = drand48()
    z = sqrt(1 - r2)
    phi = 2 * Pi * r1
    x = cos(phi) * 2 * sqrt(r2)
    y = sin(phi) * 2 * sqrt(r2)

  return newVec3(x, y, z)
