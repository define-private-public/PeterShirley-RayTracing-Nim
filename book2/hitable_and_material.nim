import vec3
import ray
import aabb


type
  hitable* = ref hitableObj
  hitableObj* = object of RootObj

  material* = ref materialObj
  materialObj* = object of RootObj

  hit_record* = ref hit_recordObj
  hit_recordObj = object of RootObj
    t*, u*, v*: float
    p*, normal*: vec3
    mat_ptr*: material


# Hitable functions
proc newHitRecord*(): hit_record =
  return hit_record(
    t: 0,
    p: newVec3(),
    normal: newVec3()
  )


method hit*(h: hitable, r: ray, t_min, t_max: float, rec: var hit_record): bool {.inline.} =
  return false


method bounding_box*(h: hitable, t0, t1: float, box: var aabb): bool {.inline.} =
  return false


# Material functions
proc newMaterial*(): material=
  return material()


method scatter*(
  mat: material,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool {.inline.} =
  return false


method emitted*(mat: material, u, v: float; p: vec3): vec3 {.inline.} =
  return newVec3(0, 0, 0)

