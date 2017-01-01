import math
import hitable_and_material
import vec3
import ray
import aabb


type
  moving_sphere* = ref object of hitable
    center0*, center1*: vec3
    time0*, time1*: float
    radius*: float
    mat_ptr*: material


proc newMovingSphere*(): moving_sphere=
  new(result)
  result.center0 = newVec3()
  result.center1 = newVec3()
  result.time0 = 0
  result.time1 = 0
  result.radius = 0


proc newMovingSphere*(cen0, cen1: vec3, t0, t1, r: float, m: material): moving_sphere=
  result = newMovingSphere()
  result.center0 = cen0
  result.center1 = cen1
  result.time0 = t0
  result.time1 = t1
  result.radius = r
  result.mat_ptr = m


proc center*(ms: moving_sphere, time: float): vec3 =
  return ms.center0 + (((time - ms.time0) / (ms.time1 - ms.time0)) * (ms.center1 - ms.center0))


method hit*(ms: moving_sphere, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let
    oc = r.origin() - ms.center(r.time)
    a = dot(r.direction(), r.direction())
    b = dot(oc, r.direction())
    c = dot(oc, oc) - (ms.radius * ms.radius)
    discriminant = (b * b) - (a * c)

  if discriminant > 0:
    var temp = (-b - sqrt((b * b) - (a * c))) / a
    if (temp < t_max) and (temp > t_min):
      rec.t = temp
      rec.p = r.point_at_parameter(rec.t)
      rec.normal = (rec.p - ms.center(r.time)) / ms.radius
      rec.mat_ptr = ms.mat_ptr

      return true
    
    temp = (-b - sqrt((b * b) - (a * c))) / a
    if (temp < t_max) and (temp > t_min):
      rec.t = temp
      rec.p = r.point_at_parameter(rec.t)
      rec.normal = (rec.p - ms.center(r.time)) / ms.radius
      rec.mat_ptr = ms.mat_ptr

      return true

  return false


method bounding_box*(ms: moving_sphere, t0, t1: float, box: var aabb): bool =
  let
    r = newVec3(ms.radius, ms.radius, ms.radius)
    box0 = newAABB(ms.center(t0) - r, ms.center(t0) + r)
    box1 = newAABB(ms.center(t1) - r, ms.center(t1) + r)

  box = surrounding_box(box0, box1)
  return true

