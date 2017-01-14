import hitable_and_material
import vec3
import ray
import aabb


type
  translate* = ref translateObj
  translateObj = object of hitableObj
    obj*: hitable
    offset*: vec3


proc newTranslate*(p: hitable; displacement: vec3): translate =
  new(result)
  result.obj = p
  result.offset = displacement


method hit*(t: translate, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let moved_r = newRay(r.origin() - t.offset, r.direction(), r.time)
  if t.obj.hit(moved_r, t_min, t_max, rec):
    rec.p += t.offset
    return true
  else:
    return false


method bounding_box*(t: translate, t0, t1: float, box: var aabb): bool =
  if t.obj.bounding_box(t0, t1, box):
    box = newAABB(box.min + t.offset, box.max + t.offset)
    return true
  else:
    return false

