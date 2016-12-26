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
  while p.dot(d) > 1:
    p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)

  return p


proc schlick*(cosine, ref_idx: float): float=
  var r0 = (1 - ref_idx) / (1 + ref_idx)
  r0 = r0 * r0
  return r0 + ((1 - r0) * pow(1 - cosine, 5))
