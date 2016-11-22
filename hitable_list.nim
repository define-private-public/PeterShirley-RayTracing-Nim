import hitable
import ray

type
  hitable_list* = ref object of hitable
    list*: seq[hitable]


proc newHitable_list*(): hitable_list=
  return hitable_list(list: @[])


proc newHitable_list*(l: seq[hitable]): hitable_list=
  return hitable_list(list: l)


method hit*(hl: hitable_list, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  var
    temp_rec: hit_record
    hit_anything = false
    closest_so_far = t_max

  for i, item in hl.list:
    if item.hit(r, t_min, closest_so_far, temp_rec):
      hit_anything = true;
      closest_so_far = temp_rec.t
      rec = temp_rec

  return hit_anything

