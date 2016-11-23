# This is a metal material

import vec3
import ray
import hitable_and_material
import util


type
  metal* = ref object of material
    albedo*: vec3


proc newMetal*(a: vec3): metal=
  return metal(albedo: a)


method scatter*(
  met: metal,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool=
  let reflected = reflect(r_in.direction().unit_vector(), rec.normal)
  scattered = newRay(rec.p, reflected)
  attenuation = met.albedo

  return (dot(scattered.direction(), rec.normal) > 0)

