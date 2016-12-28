# This is also known as a "diffuse," material

import math
import vec3
import ray
import hitable_and_material
import util
import texture, constant_texture
import onb


type
  lambertian* = ref object of material
    albedo*: texture


proc newLambertian*(a: texture): lambertian=
  return lambertian(albedo: a)


method scatter*(
  lamb: lambertian,
  r_in: ray,
  rec: hit_record,
  alb: var vec3,
  scattered: var ray,
  pdf: var float
): bool=
  var uvw:onb
  uvw.build_from_w(rec.normal)

  let direction = uvw.local(random_cosine_direction())

  scattered = newRay(rec.p, unit_vector(direction), r_in.time)
  alb = lamb.albedo.value(rec.u, rec.v, rec.p)
  pdf = dot(uvw.w, scattered.direction) / Pi

  return true


method scattering_pdf*(
  lamb: lambertian,
  r_in: ray,
  rec: hit_record,
  scattered: ray
): float =
  var cosine = dot(rec.normal, unit_vector(scattered.direction))

  if cosine < 0:
    cosine = 0

  return cosine / Pi


