import hitable_and_material
import vec3
import ray
import aabb
import texture
import isotropic


type
  constant_medium* = ref object of hitable
    boundary*: hitable
    density*: float
    phase_function*: material


proc newConstantMedium*(b: hitable, d: float, a: texture): constant_medium =
  new(result)
  result.boundary = b
  result.density = d
  result.phase_function = newIsotrpoic(a)


method hit*(cm: constant_medium, r: ray, t_min, t_max: float, rec: var hit_record): bool =
  return false


method bounding_box*(cm: constant_medium, t0, t1: float, box: var aabb): bool =
  return cm.boundary.bounding_box(t0, t1, box)

