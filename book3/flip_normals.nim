import hitable_and_material
import vec3
import ray
import aabb


type
  flip_normals* = ref object of hitable
    obj*: hitable


proc newFlipNormals*(o: hitable): flip_normals =
  new(result)
  result.obj = o


method hit*(fn: flip_normals, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  if fn.obj.hit(r, t_min, t_max, rec):
    rec.normal = -rec.normal
    return true
  else:
    return false


method bounding_box*(fn: flip_normals, t0, t1: float, box: var aabb): bool =
  return fn.obj.bounding_box(t0, t1, box)

