import math
import hitable_and_material
import vec3
import ray
import aabb
import util


type
  bvh_node* = ref object of hitable
    left*, right*: hitable
    box*: aabb


proc newBVHNode*(): bvh_node =
  new(result)
  result.box = newAABB()


proc newBVHNode*(l: seq[hitable], time0, time1: float): bvh_node =
  result = newBVHNode()

  let
    n = l.len
    axis = (3 * drand48()).int

  # TODO need a qsort
  if axis == 0:
    discard
  elif axis == 1:
    discard
  else:
    discard

  if n == 1:
    result.left = l[0]
    result.right = l[0]
  elif n == 2:
    result.left = l[0]
    result.right = l[1]
  else:
    # TODO need to split the lists
    result.left = newBVHNode()
    result.right = newBVHNode()

  var box_left, box_right: aabb
  if (not result.left.bounding_box(time0, time1, box_left)) or
     (not result.right.bounding_box(time0, time1, box_right)):
    stderr.write("no bounding box in bvh_node constructor\n")

  result.box = surrounding_box(box_left, box_right)


method hit*(node: bvh_node, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  if node.box.hit(r, t_min, t_max):
    var
      left_rec, right_rec: hit_record
      hit_left = node.left.hit(r, t_min, t_max, left_rec)
      hit_right = node.right.hit(r, t_min, t_max, right_rec)

    if hit_left and hit_right:
      if left_rec.t < right_rec.t:
        rec = left_rec
      else:
        rec = right_rec

      return true
    elif hit_left:
      rec = left_rec
      return true
    elif hit_right:
      rec = right_rec
      return true
    else:
      return false
  else:
    return false


method bounding_box*(node: bvh_node, t0, t1: float, box: var aabb): bool =
  box = node.box
  return true

