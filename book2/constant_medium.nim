import math
import hitable_and_material
import vec3
import ray
import aabb
import texture
import isotropic
import util


type
  constant_medium* = ref constant_mediumObj
  constant_mediumObj = object of hitable
    boundary*: hitable
    density*: float
    phase_function*: material


proc newConstantMedium*(b: hitable, d: float, a: texture): constant_medium =
  new(result)
  result.boundary = b
  result.density = d
  result.phase_function = newIsotrpoic(a)


method hit*(cm: constant_medium, r: ray, t_min, t_max: float, rec: var hit_record): bool =
  var db = (drand48() < 0.00001)
  db = false

  var
    rec1 = newHitRecord()
    rec2 = newHitRecord()

  # NOTE: FLT_MAX doesn't exist in Nim, so this is here instead
  const FLT_MAX = 1_000_000

  if cm.boundary.hit(r, -FLT_MAX, FLT_MAX, rec1):
    if cm.boundary.hit(r, rec1.t + 0.0001, FLT_MAX, rec2):
      if rec1.t < t_min:
        rec1.t = t_min

      if rec2.t > t_max:
        rec2.t = t_max

      if rec1.t >= rec2.t:
        return false

      if rec1.t < 0:
        rec1.t = 0

      let
        distance_inside_boundary = (rec2.t - rec1.t) * r.direction().length
        hit_distance = -(1 / cm.density) * ln(drand48())

      if (hit_distance < distance_inside_boundary):
        rec.t = rec1.t + (hit_distance / r.direction().length)
        rec.p = r.point_at_parameter(rec.t)
        rec.normal = newVec3(1, 0, 0)   # This is arbitrary but needed
        rec.mat_ptr = cm.phase_function
        return true

  return false


method bounding_box*(cm: constant_medium, t0, t1: float, box: var aabb): bool {.inline.} =
  return cm.boundary.bounding_box(t0, t1, box)

