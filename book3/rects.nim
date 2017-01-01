# This file contains the the xy_rect, xz_rect, and yz_rects

import hitable_and_material
import vec3
import ray
import aabb
import util


type
  xy_rect* = ref object of hitable
    mp*: material
    x0*, x1*, y0*, y1*, k*: float

  xz_rect* = ref object of hitable
    mp*: material
    x0*, x1*, z0*, z1*, k*: float

  yz_rect* = ref object of hitable
    mp*: material
    y0*, y1*, z0*, z1*, k*: float




# xy_rect methods
proc newXYRect*(): xy_rect =
  new(result)


proc newXYRect*(x0, x1, y0, y1, k: float; mat: material): xy_rect =
  result = newXYRect()
  result.x0 = x0
  result.x1 = x1
  result.y0 = y0
  result.y1 = y1
  result.k = k
  result.mp = mat


method hit*(rect: xy_rect, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let t = (rect.k - r.origin().z) / r.direction().z
  if (t < t_min) or (t > t_max):
    return false

  let
    x = r.origin().x + (t * r.direction().x)
    y = r.origin().y + (t * r.direction().y)

  if (x < rect.x0) or (x > rect.x1) or (y < rect.y0) or (y > rect.y1):
    return false

  rec.u = (x - rect.x0) / (rect.x1 - rect.x0)
  rec.v = (y - rect.y0) / (rect.y1 - rect.y0)
  rec.t = t
  rec.mat_ptr = rect.mp
  rec.p = r.point_at_parameter(t)
  rec.normal = newVec3(0, 0, 1)
  return true


method bounding_box*(rect: xy_rect, t0, t1: float, box: var aabb): bool =
  box = newAABB(newVec3(rect.x0, rect.y0, rect.k - 0.0001),
                newVec3(rect.x1, rect.y1, rect.k + 0.0001))
  return true



# xz_rect methods
proc newXZRect*(): xz_rect =
  new(result)


proc newXZRect*(x0, x1, z0, z1, k: float; mat: material): xz_rect =
  result = newXZRect()
  result.x0 = x0
  result.x1 = x1
  result.z0 = z0
  result.z1 = z1
  result.k = k
  result.mp = mat


method hit*(rect: xz_rect, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let t = (rect.k - r.origin().y) / r.direction().y
  if (t < t_min) or (t > t_max):
    return false

  let
    x = r.origin().x + (t * r.direction().x)
    z = r.origin().z + (t * r.direction().z)

  if (x < rect.x0) or (x > rect.x1) or (z < rect.z0) or (z > rect.z1):
    return false

  rec.u = (x - rect.x0) / (rect.x1 - rect.x0)
  rec.v = (z - rect.z0) / (rect.z1 - rect.z0)
  rec.t = t
  rec.mat_ptr = rect.mp
  rec.p = r.point_at_parameter(t)
  rec.normal = newVec3(0, 1, 0)
  return true


method bounding_box*(rect: xz_rect, t0, t1: float, box: var aabb): bool =
  box = newAABB(newVec3(rect.x0, rect.k - 0.0001, rect.z0),
                newVec3(rect.x1, rect.k + 0.0001, rect.z1))
  return true


method pdf_value*(rect: xz_rect; o, v: vec3):float =
  var rec = newHitRecord()
  # NOTE: Using 1 mil intead of FLOAT_MAX:
  if rect.hit(newRay(o, v), 0.001, 1_000_000, rec):
    let
      area = (rect.x1 - rect.x0) * (rect.z1 - rect.z0)
      distance_squared = rec.t * rec.t * v.squared_length()
      cosine = abs(dot(v, rec.normal) / v.length)

    return distance_squared / (cosine * area)
  else:
    return 0


method random*(rect: xz_rect; o: vec3):vec3 =
  let random_point = newVec3(
    rect.x0 + (drand48() * (rect.x1 - rect.x0)),
    rect.k,
    rect.z0 + (drand48() * (rect.z1 - rect.z0))
  )

  return random_point - o



# yz_rect methods
proc newYZRect*(): yz_rect =
  new(result)


proc newYZRect*(y0, y1, z0, z1, k: float; mat: material): yz_rect =
  result = newYZRect()
  result.y0 = y0
  result.y1 = y1
  result.z0 = z0
  result.z1 = z1
  result.k = k
  result.mp = mat


method hit*(rect: yz_rect, r: ray, t_min, t_max: float, rec: var hit_record): bool=
  let t = (rect.k - r.origin().x) / r.direction().x
  if (t < t_min) or (t > t_max):
    return false

  let
    y = r.origin().y + (t * r.direction().y)
    z = r.origin().z + (t * r.direction().z)

  if (y < rect.y0) or (y > rect.y1) or (z < rect.z0) or (z > rect.z1):
    return false

  rec.u = (y - rect.y0) / (rect.y1 - rect.y0)
  rec.v = (z - rect.z0) / (rect.z1 - rect.z0)
  rec.t = t
  rec.mat_ptr = rect.mp
  rec.p = r.point_at_parameter(t)
  rec.normal = newVec3(1, 0, 0)
  return true


method bounding_box*(rect: yz_rect, t0, t1: float, box: var aabb): bool =
  box = newAABB(newVec3(rect.k - 0.0001, rect.y0, rect.z0),
                newVec3(rect.k + 0.0001, rect.y1, rect.z1))
  return true

