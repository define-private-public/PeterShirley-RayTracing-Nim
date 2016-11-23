# This is also known as a "diffuse," material

import vec3
import ray
import hitable_and_material
import util


type
  lambertian* = ref object of material
    albedo*: vec3


proc newLambertian*(a: vec3): lambertian=
  return lambertian(albedo: a)


method scatter*(
  lamb: lambertian,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool=
  let target = rec.p + rec.normal + random_in_unit_sphere()
  scattered = newRay(rec.p, target - rec.p)
  attenuation = lamb.albedo

  return true

