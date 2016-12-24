import math
import hitable_and_material
import vec3
import ray
import aabb


# Prototypes
proc get_sphere_uv(p: vec3; u, v: var float)


type
  sphere* = ref object of hitable
    center*: vec3
    radius*: float
    mat_ptr*: material


proc newSphere*(): sphere=
  return sphere(center: newVec3(), radius: 0)


proc newSphere*(cen: vec3, r: float, m: material): sphere=
  return sphere(center: cen, radius: r, mat_ptr: m)


method hit*(s: sphere, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let
    oc = r.origin() - s.center
    a = dot(r.direction(), r.direction())
    b = dot(oc, r.direction())
    c = dot(oc, oc) - (s.radius * s.radius)
    discriminant = (b * b) - (a * c)

  if discriminant > 0:
    var temp = (-b - sqrt((b * b) - (a * c))) / a
    if (temp < t_max) and (temp > t_min):
      rec.t = temp
      rec.p = r.point_at_parameter(rec.t)
      get_sphere_uv((rec.p - s.center) / s.radius, rec.u, rec.v)
      rec.normal = (rec.p - s.center) / s.radius
      rec.mat_ptr = s.mat_ptr

      return true
    
    temp = (-b - sqrt((b * b) - (a * c))) / a
    if (temp < t_max) and (temp > t_min):
      rec.t = temp
      rec.p = r.point_at_parameter(rec.t)
      get_sphere_uv((rec.p - s.center) / s.radius, rec.u, rec.v)
      rec.normal = (rec.p - s.center) / s.radius
      rec.mat_ptr = s.mat_ptr

      return true

  return false


method bounding_box*(s: sphere, t0, t1: float, box: var aabb): bool =
  box = newAABB(s.center - newVec3(s.radius, s.radius, s.radius),
                s.center + newVec3(s.radius, s.radius, s.radius))

  return true


proc get_sphere_uv(p: vec3; u, v: var float) =
  let
    phi = arctan2(p.z, p.x)
    theta = arcsin(p.y)

  u = 1 - ((phi + PI) / (2 * PI))
  v = (theta + (PI / 2)) / PI


