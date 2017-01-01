# This is also known as a "diffuse," material

import math
import vec3
import ray
import hitable_and_material
import util
import texture, constant_texture
import onb
import cosine_pdf


type
  lambertian* = ref object of material
    albedo*: texture


proc newLambertian*(a: texture): lambertian=
  return lambertian(albedo: a)


method scatter*(
  lamb: lambertian,
  r_in: ray,
  hrec: hit_record,
  srec: var scatter_record
): bool=
  srec.is_specular = false
  srec.attenuation = lamb.albedo.value(hrec.u, hrec.v, hrec.p)
  srec.pdf_ptr = newCosinePDF(hrec.normal)

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


