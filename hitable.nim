import vec3
import ray


type
  hit_record* = ref object of RootObj
    t*: float
    p*, normal*: vec3


  hitable* = ref object of RootObj


proc newHitRecord*(): hit_record=
  return hit_record(
    t: 0,
    p: newVec3(),
    normal: newVec3()
  )


method hit*(h: hitable, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  return false

