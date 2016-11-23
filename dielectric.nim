# A Dieletric (refractable) material (e.g. glass)

import vec3
import ray
import hitable_and_material
import util


type
  dielectric* = ref object of material
    ref_idx*: float


proc newDielectric*(ri: float): dielectric=
  return dielectric(ref_idx: ri)


method scatter*(
  dielec: dielectric,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool=
  var
    outward_normal = newVec3()
    ni_over_nt: float
    refracted = newVec3()

  let
    reflected = r_in.direction().reflect(rec.normal)

  attenuation = newVec3(1, 1, 1)

  if r_in.direction().dot(rec.normal) > 0:
    outward_normal = -rec.normal
    ni_over_nt = dielec.ref_idx
  else:
    outward_normal = rec.normal
    ni_over_nt = 1 / dielec.ref_idx

  if refract(r_in.direction(), outward_normal, ni_over_nt, refracted):
    scattered = newRay(rec.p, refracted)
  else:
    scattered = newRay(rec.p, reflected)
    return false

  return true


