import hitable_and_material
import vec3
import ray
import aabb


type
  xy_rect* = ref object of hitable
    mp*: material
    x0*, x1*, y0*, y1*, k*: float


proc newXYRect*(): xy_rect =
  new(result)


proc newXYRect*(x0, x1, y0, y1, k: float; mat: material): xy_rect =
  result = newXYRect()
  result.x0 = x0
  result.x1 = x1
  result.y0 = y0
  result.y1 = y1
  result.k = k
  result.mp = mat


method hit*(rect: xy_rect, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let t = (rect.k - r.origin().z) / r.direction().z
  if (t < t_min) or (t > t_max):
    return false

  let
    x = r.origin().x + (t * r.direction().x)
    y = r.origin().y + (t * r.direction().y)

  if (x < rect.x0) or (x > rect.x1) or (y < rect.y0) or (y > rect.y1):
    return false

  rec.u = (x - rect.x0) / (rect.x1 - rect.x0)
  rec.v = (y - rect.y0) / (rect.y1 - rect.y0)
  rec.t = t
  rec.mat_ptr = rect.mp
  rec.p = r.point_at_parameter(t)
  rec.normal = newVec3(0, 0, 0)
  return true


method bounding_box*(rect: xy_rect, t0, t1: float, box: var aabb): bool =
  box = newAABB(newVec3(rect.x0, rect.y0, rect.k - 0.0001),
                newVec3(rect.x1, rect.y1, rect.k + 0.0001))
  return true
