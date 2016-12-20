import math
import hitable_and_material
import vec3
import ray
import aabb

  
type
  rotate_y* = ref object of hitable
    obj*: hitable
    sin_theta*, cos_theta*: float
    hasbox*: bool
    bbox*: aabb


proc newRotateY*(p: hitable; angle: float): rotate_y =
  new(result)
  result.obj = p

  let radians = (PI / 180) * angle
  result.sin_theta = sin(radians)
  result.cos_theta = cos(radians)
  result.hasbox = result.obj.bounding_box(0, 1, result.bbox)

  # NOTE: FLT_MAX and don't exist in Nim, so, I did this instead:
  const FLT_MAX = 1_000_000.0
  var
    min = newVec3(FLT_MAX, FLT_MAX, FLT_MAX)
    max = newVec3(-FLT_MAX, -FLT_MAX, -FLT_MAX)

  for i in countup(0, 1):
    for j in countup(0, 1):
      for k in countup(0, 1):
        let
          x = (i.float * result.bbox.max.x) + ((1 - i.float) * result.bbox.min.x)
          y = (j.float * result.bbox.max.y) + ((1 - j.float) * result.bbox.min.y)
          z = (k.float * result.bbox.max.z) + ((1 - k.float) * result.bbox.min.z)
          newx = (result.cos_theta * x) + (result.sin_theta * z)
          newz = (-result.sin_theta * x) + (result.cos_theta * z)
          tester = newVec3(newx, y, newz)

        for c in countup(0, 2):
          if tester[c] > max[c]:
            max[c] = tester[c]
          if tester[c] < min[c]:
            min[c] = tester[c]

  result.bbox = newAABB(min, max)


method hit*(ry: rotate_y, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  # TODO fix clone issues
  var
    origin = newVec3(r.origin())
    direction = newVec3(r.direction())

  origin[0] = (ry.cos_theta * r.origin()[0]) - (ry.sin_theta * r.origin()[2])
  origin[2] = (ry.sin_theta * r.origin()[0]) + (ry.cos_theta * r.origin()[2])
  direction[0] = (ry.cos_theta * r.direction()[0]) - (ry.sin_theta * r.direction()[2])
  direction[2] = (ry.sin_theta * r.direction()[0]) + (ry.cos_theta * r.direction()[2])

  let rotated_r = newRay(origin, direction, r.time)

  if ry.obj.hit(rotated_r, t_min, t_max, rec):
    var
      p = rec.p
      normal = rec.normal

    p[0] = (ry.cos_theta * rec.p[0]) + (ry.sin_theta * rec.p[2])
    p[2] = (-ry.sin_theta * rec.p[0]) + (ry.cos_theta * rec.p[2])
    normal[0] = (ry.cos_theta * rec.normal[0]) + (ry.sin_theta * rec.normal[2])
    normal[2] = (-ry.sin_theta * rec.normal[0]) + (ry.cos_theta * rec.normal[2])

    rec.p = p
    rec.normal = normal
    return true
  else:
    return false


method bounding_box*(ry: rotate_y, t0, t1: float, box: var aabb): bool =
  box = ry.bbox
  return ry.hasbox

