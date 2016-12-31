# This is a metal material

import vec3
import ray
import hitable_and_material
import util


type
  metal* = ref object of material
    albedo*: vec3
    fuzz*: float


proc newMetal*(a: vec3, f: float): metal=
  var fz:float

  if f < 1:
    fz = f
  else:
    fz = 1

  return metal(albedo: a, fuzz: f)


method scatter*(
  met: metal,
  r_in: ray,
  hrec: hit_record,
  srec: var scatter_record
): bool=
  let reflected = reflect(r_in.direction(), hrec.normal)

  srec.specular_ray = newRay(hrec.p, reflected + (met.fuzz * random_in_unit_sphere()))
  srec.attenuation = met.albedo
  srec.is_specular = true
  srec.pdf_ptr = nil

  return true

