import vec3
import ray
import aabb
import pdf


type
  hitable* = ref hitableObj
  hitableObj* = object of RootObj

  material* = ref materialObj
  materialObj* = object of RootObj

  hit_record* = object
    t*, u*, v*: float
    p*, normal*: vec3
    mat_ptr*: material

  scatter_record* = object
    specular_ray*: ray
    is_specular*: bool
    attenuation*: vec3
    pdf_ptr*: pdf

# Hitable functions
proc newHitRecord*(): hit_record =
  return hit_record(
    t: 0,
    p: newVec3(),
    normal: newVec3()
  )


proc newScatterRecord*():scatter_record =
  return scatter_record(
    specular_ray: newRay(),
    is_specular: false,
    attenuation: newVec3(),
    pdf_ptr: newPDF()
  )


# Hitable functions
method hit*(h: hitable, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  return false


method bounding_box*(h: hitable, t0, t1: float, box: var aabb): bool {.inline.} =
  return false


method pdf_value*(h: hitable; o, v: vec3): float {.inline.} =
  return 0.0


method random*(h: hitable; o: vec3): vec3 {.inline.} =
  return newVec3(1, 0, 0)


# Material functions
proc newMaterial*(): material=
  return material()


method scatter*(
  mat: material,
  r_in: ray,
  hrec: hit_record,
  srec: var scatter_record
): bool {.inline.} =
  return false


method scattering_pdf*(
  mat: material,
  r_in: ray,
  rec: hit_record,
  scattered: ray
): float {.inline.} =
  return 0


method emitted*(
  mat: material;
  r_in: ray;
  rec: hit_record;
  u, v: float;
  p: vec3
): vec3 {.inline.} =
  return newVec3(0, 0, 0)

