import vec3
import ray


type
  hitable* = ref hitableObj
  hitableObj* = object of RootObj

  material* = ref materialObj
  materialObj* = object of RootObj

  hit_record* = object
    t*: float
    p*, normal*: vec3
    mat_ptr*: material


# Hitable functions
proc newHitRecord*(): hit_record=
  return hit_record(
    t: 0,
    p: newVec3(),
    normal: newVec3()
  )


method hit*(h: hitable, r: ray, t_min, t_max: float, rec: var hit_record): bool=
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
): bool=
  return false

