# This is also known as a "diffuse," material

import math
import vec3
import ray
import hitable_and_material
import util
import texture, constant_texture


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
#  let target = rec.p + rec.normal + random_in_unit_sphere()
#  scattered = newRay(rec.p, unit_vector(target - rec.p), r_in.time)
#  alb = lamb.albedo.value(rec.u, rec.v, rec.p)
#  pdf = dot(rec.normal, scattered.direction) / Pi

  # NOTE: there are no do-while loops in nim, so this is what we have to do instead
  var direction = random_in_unit_sphere()
  while dot(direction, rec.normal) < 0:
    direction = random_in_unit_sphere()

  scattered = newRay(rec.p, unit_vector(direction), r_in.time)
  alb = lamb.albedo.value(rec.u, rec.v, rec.p)
  pdf = 0.5 / Pi

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


