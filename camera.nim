import math
import vec3
import ray


type
  camera* = ref object of RootObj
    origin*, lower_left_corner*, horizontal*, vertical*: vec3


proc newCamera*(vfov, aspect: float): camera=
  let
    theta = vfov * (PI / 180)
    half_height = tan(theta / 2)
    half_width = aspect * half_height

  return camera(
    lower_left_corner: newVec3(-half_width, -half_height, -1),
    horizontal: newVec3(2 * half_width, 0, 0),
    vertical: newVec3(0, 2 * half_height, 0),
    origin: newVec3(0, 0, 0)
  )


proc get_ray*(c: camera, u, v: float): ray=
  return newRay(
    c.origin,
    c.lower_left_corner + (u * c.horizontal) + (v * c.vertical) - c.origin
  )

