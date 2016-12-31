import hitable_and_material
import ray
import aabb
import vec3
import util


type
  hitable_list* = ref object of hitable
    list*: seq[hitable]


proc newHitableList*(): hitable_list=
  return hitable_list(list: @[])


proc newHitableList*(l: seq[hitable]): hitable_list=
  return hitable_list(list: l)


method hit*(hl: hitable_list, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  var
    temp_rec = newHitRecord()
    hit_anything = false
    closest_so_far = t_max

  for i, item in hl.list:
    if item.hit(r, t_min, closest_so_far, temp_rec):
      hit_anything = true;
      closest_so_far = temp_rec.t
      rec = temp_rec

  return hit_anything


method bounding_box*(hl: hitable_list, t0, t1: float, box: var aabb): bool =
  if hl.list.len < 1:
    return false

  var
    temp_box = newAABB()
    first_true = hl.list[0].bounding_box(t0, t1, temp_box)

  if not first_true:
    return false
  else:
    box = temp_box

  for i in countup(1, hl.list.len - 1):
    if hl.list[i].bounding_box(t0, t1, temp_box):
      box = surrounding_box(box, temp_box)
    else:
      return false

  return true


method pdf_value*(hl: hitable_list; o, v: vec3):float =
  let weight = 1 / hl.list.len
  var sum:float

  for i in countup(0, hl.list.len - 1):
    sum += weight * hl.list[i].pdf_value(o, v)

  return sum

method random*(hl: hitable_list; o: vec3):vec3 =
  let index = (drand48() * hl.list.len.float).int
  return hl.list[index].random(o)

