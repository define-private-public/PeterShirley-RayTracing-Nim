import vec3
import ray


type
  camera* = ref object of RootObj
    origin*, lower_left_corner*, horizontal*, vertical*: vec3


proc newCamera*(): camera=
  return camera(
    lower_left_corner: newVec3(-2, -1, -1),
    horizontal: newVec3(4, 0, 0),
    vertical: newVec3(0, 2, 0),
    origin: newVec3(0, 0, 0)
  )


proc get_ray*(c: camera, u, v: float): ray=
  return newRay(
    c.origin,
    c.lower_left_corner + (u * c.horizontal) + (v * c.vertical) - c.origin
  )

