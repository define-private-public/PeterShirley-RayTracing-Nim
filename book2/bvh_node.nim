import math
import algorithm
import sequtils
import hitable_and_material
import vec3
import ray
import aabb
import util


# function prototypes for AABB sorting
proc box_x_compare(ah, bh: hitable): int
proc box_y_compare(ah, bh: hitable): int
proc box_z_compare(ah, bh: hitable): int


type
  bvh_node* = ref bvh_nodeObj
  bvh_nodeObj = object of hitableObj
    left*, right*: hitable
    box*: aabb


proc newBVHNode*(): bvh_node =
  new(result)
  result.box = newAABB()


proc newBVHNode*(l: var seq[hitable], time0, time1: float): bvh_node =
  result = newBVHNode()

  let
    n = l.len
    axis = (3 * drand48()).int

  if axis == 0:
    sort(l, box_x_compare)
  elif axis == 1:
    sort(l, box_y_compare)
  else:
    sort(l, box_z_compare)

  if n == 1:
    result.left = l[0]
    result.right = l[0]
  elif n == 2:
    result.left = l[0]
    result.right = l[1]
  else:
    # Split the list in half
    var
      l_dist = l.distribute(2)
      l1 = l_dist[0]
      l2 = l_dist[1]

    result.left = newBVHNode(l1, time0, time1)
    result.right = newBVHNode(l2, time0, time1)

  var box_left, box_right: aabb
  if (not result.left.bounding_box(time0, time1, box_left)) or
     (not result.right.bounding_box(time0, time1, box_right)):
    stderr.write("no bounding box in bvh_node constructor\n")

  result.box = surrounding_box(box_left, box_right)


method hit*(node: bvh_node, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  if node.box.hit(r, t_min, t_max):
    var
      left_rec = newHitRecord()
      right_rec = newHitRecord()

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


method bounding_box*(node: bvh_node, t0, t1: float, box: var aabb): bool {.inline.} =
  box = node.box
  return true


# For AABB sorting (along an axis)
proc box_x_compare(ah, bh: hitable): int =
  var box_left, box_right: aabb

  if (not ah.bounding_box(0, 0, box_left)) or (not bh.bounding_box(0, 0, box_right)):
    stderr.write("no bounding box in bvh_node constructor\n")

  if (box_left.min.x - box_right.min.x) < 0:
    return -1
  else:
    return 1


proc box_y_compare(ah, bh: hitable): int =
  var box_left, box_right: aabb

  if (not ah.bounding_box(0, 0, box_left)) or (not bh.bounding_box(0, 0, box_right)):
    stderr.write("no bounding box in bvh_node constructor\n")

  if (box_left.min.y - box_right.min.y) < 0:
    return -1
  else:
    return 1


proc box_z_compare(ah, bh: hitable): int =
  var box_left, box_right: aabb

  if (not ah.bounding_box(0, 0, box_left)) or (not bh.bounding_box(0, 0, box_right)):
    stderr.write("no bounding box in bvh_node constructor\n")

  if (box_left.min.z - box_right.min.z) < 0:
    return -1
  else:
    return 1

