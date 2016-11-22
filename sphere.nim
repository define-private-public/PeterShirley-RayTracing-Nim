import math
import hitable
import vec3
import ray

type
  sphere* = ref object of hitable
    center: vec3
    radius: float


proc newSphere*(): sphere=
  return sphere(center: newVec3(), radius: 0)


proc newSphere*(cen: vec3, r: float): sphere=
  return sphere(center: cen, radius: r)


method hit*(s: sphere, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let
    oc = r.origin() - s.center
    a = dot(r.direction(), r.direction())
    b = 2 * dot(oc, r.direction())
    c = dot(oc, oc) - (s.radius * s.radius)
    discriminant = (b * b) - (4 * a * c)

  if discriminant > 0:
    var temp = (-b - sqrt((b * b) - (a * c))) / a
    if (temp < t_max) and (temp > t_min):
      rec.t = temp
      rec.p = r.point_at_parameter(rec.t)
      rec.normal = (rec.p - s.center) / s.radius

      return true
    
    temp = (-b - sqrt((b * b) - (a * c))) / a
    if (temp < t_max) and (temp > t_min):
      rec.t = temp
      rec.p = r.point_at_parameter(rec.t)
      rec.normal = (rec.p - s.center) / s.radius

      return true

  return false

