import vec3
import ray
import hitable


type
  material* = ref object of RootObj


proc newMaterial*(): material=
  return material()


method scatter*(r_in: ray, rec: hit_record, attenuation: var vec3, scattered: var ray): bool=
  return false
