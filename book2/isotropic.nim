import hitable_and_material
import vec3
import ray
import aabb
import texture
import util


type
  isotropic* = ref object of material
    albedo*: texture


proc newIsotrpoic*(a: texture): isotropic =
  new(result)
  result.albedo = a


method scatter*(
  iso: isotropic,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool =
  scattered = newRay(rec.p, random_in_unit_sphere())
  attenuation = iso.albedo.value(rec.u, rec.v, rec.p)
  return true

