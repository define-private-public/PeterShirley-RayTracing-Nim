# This is also known as a "diffuse," material

import vec3
import ray
import hitable_and_material
import util
import texture, constant_texture


type
  lambertian* = ref lambertainObj
  lambertainObj = object of materialObj
    albedo*: texture


proc newLambertian*(a: texture): lambertian=
  return lambertian(albedo: a)


method scatter*(
  lamb: lambertian,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool {.inline.} =
  let target = rec.p + rec.normal + random_in_unit_sphere()
  scattered = newRay(rec.p, target - rec.p, r_in.time)
  attenuation = lamb.albedo.value(rec.u, rec.v, rec.p)

  return true

