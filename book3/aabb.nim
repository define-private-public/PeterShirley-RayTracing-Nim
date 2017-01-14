import vec3
import ray


proc ffmin*(a, b: float): float {.inline.} =
  if a < b:
    return a
  else:
    return b


proc ffmax*(a, b: float): float {.inline.} =
  if a > b:
    return a
  else:
    return b


type
  aabb* = object
    min*, max*: vec3


proc newAABB*(): aabb {.inline.} =
  return aabb(min: newVec3(), max: newVec3())


proc newAABB*(a, b: vec3): aabb =
  result = newAABB()
  result.min = a
  result.max = b


#proc hit*(box: aabb, r: ray, tmin, tmax: float): bool =
#  for a in countup(0, 2):
#    let
#      t0 = ffmin((box.min[a] - r.origin()[a]) / r.direction()[a],
#                 (box.max[a] - r.origin()[a]) / r.direction()[a])
#      t1 = ffmax((box.min[a] - r.origin()[a]) / r.direction()[a],
#                 (box.max[a] - r.origin()[a]) / r.direction()[a])
#
#      # Can't reassign tmin and tmax like in C/C++, so giving these a 2 at the end
#      tmin2 = ffmax(t0, tmin)
#      tmax2 = ffmin(t1, tmax)
#
#    if tmax2 <= tmin2:
#      return false
#
#  return true


# This proc below was also in the book as an intersection method.  It was
# developered originally by Andrew Kensler (at Pixar)
proc hit*(box: aabb, r: ray, tmin, tmax: float): bool =
  for a in countup(0, 2):
    var
      invD = 1 / r.direction()[a]
      t0 = (box.min[a] - r.origin()[a]) * invD
      t1 = (box.max[a] - r.origin()[a]) * invD

    if invD < 0:
      swap(t0, t1)

    let
      # Can't reassign tmin and tmax like in C/C++, so giving these a 2 at the end
      tmin2 = if (t0 > tmin): t0 else: tmin
      tmax2 = if (t1 < tmax): t1 else: tmax

    if tmax2 <= tmin2:
      return false
  
  return true


proc surrounding_box*(box0, box1: aabb): aabb {.inline.} =
  let
    small = newVec3(min(box0.min.x, box1.min.x),
                    min(box0.min.y, box1.min.y),
                    min(box0.min.z, box1.min.z))
    big = newVec3(max(box0.max.x, box1.max.x),
                  max(box0.max.y, box1.max.y),
                  max(box0.max.z, box1.max.z))

  return newAABB(small, big)

