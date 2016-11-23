import math
import vec3
import ray


type
  camera* = ref object of RootObj
    origin*, lower_left_corner*, horizontal*, vertical*: vec3


proc newCamera*(lookfrom, lookat, vup: vec3, vfov, aspect: float): camera=
  let
    theta = vfov * (PI / 180)
    half_height = tan(theta / 2)
    half_width = aspect * half_height
    origin = lookfrom
    w = unit_vector(lookfrom - lookat)
    u = unit_vector(vup.cross(w))
    v = w.cross(u)

  return camera(
    lower_left_corner: origin - (half_width * u) - (half_height * v) - w,
    horizontal: 2 * half_width * u,
    vertical: 2 * half_height * v,
    origin: origin
  )


proc get_ray*(c: camera, u, v: float): ray=
  return newRay(
    c.origin,
    c.lower_left_corner + (u * c.horizontal) + (v * c.vertical) - c.origin
  )

