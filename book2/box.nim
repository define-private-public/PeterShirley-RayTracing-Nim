import hitable_and_material
import vec3
import ray
import aabb
import hitable_list, rects, flip_normals


type
  box* = ref boxObj
  boxObj = object of hitableObj
    pmin*, pmax*:vec3
    list_ptr*: hitable


proc newBox*(): box =
  new(result)
  result.pmin = newVec3()
  result.pmax = newVec3()


proc newBox*(p0, p1: vec3; mat: material): box =
  result = newBox()
  result.pmin = p0
  result.pmax = p1

  var list: seq[hitable] = @[]
  list.add(newXYRect(p0.x, p1.x, p0.y, p1.y, p1.z, mat))
  list.add(newFlipNormals(newXYRect(p0.x, p1.x, p0.y, p1.y, p0.z, mat)))
  list.add(newXZRect(p0.x, p1.x, p0.z, p1.z, p1.y, mat))
  list.add(newFlipNormals(newXZRect(p0.x, p1.x, p0.z, p1.z, p0.y, mat)))
  list.add(newYZRect(p0.y, p1.y, p0.z, p1.z, p1.x, mat))
  list.add(newFlipNormals(newYZRect(p0.y, p1.y, p0.z, p1.z, p0.x, mat)))

  result.list_ptr = newHitableList(list)


method hit*(b: box, r: ray, t_min, t_max: float, rec: var hit_record): bool {.inline.} =
  return b.list_ptr.hit(r, t_min, t_max, rec)


method bounding_box*(b: box, t0, t1: float, box: var aabb): bool {.inline.} =
  box = newAABB(b.pmin, b.pmax)
  return true

