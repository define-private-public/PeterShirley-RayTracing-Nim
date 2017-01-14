# A Dieletric (refractable) material (e.g. glass)

import vec3
import ray
import hitable_and_material
import util


type
  dielectric* = ref dielectricObj
  dielectricObj = object of materialObj
    ref_idx*: float


proc newDielectric*(ri: float): dielectric=
  return dielectric(ref_idx: ri)


method scatter*(
  dielec: dielectric,
  r_in: ray,
  hrec: hit_record,
  srec: var scatter_record
): bool=
  srec.is_specular = true
  srec.pdf_ptr = nil
  srec.attenuation = newVec3(1, 1, 1)

  var
    outward_normal = newVec3()
    ni_over_nt: float
    refracted = newVec3()
    reflect_prob: float
    cosine: float

  let
    reflected = r_in.direction().reflect(hrec.normal)


  if r_in.direction().dot(hrec.normal) > 0:
    outward_normal = -hrec.normal
    ni_over_nt = dielec.ref_idx
    cosine = dielec.ref_idx * r_in.direction().dot(hrec.normal) / (r_in.direction().length())
  else:
    outward_normal = hrec.normal
    ni_over_nt = 1 / dielec.ref_idx
    cosine = -r_in.direction().dot(hrec.normal) / (r_in.direction().length())

  if refract(r_in.direction(), outward_normal, ni_over_nt, refracted):
    reflect_prob = schlick(cosine, dielec.ref_idx)
  else:
    reflect_prob = 1

  if drand48() < reflect_prob:
    srec.specular_ray = newRay(hrec.p, reflected)
  else:
    srec.specular_ray = newRay(hrec.p, refracted)

  return true

