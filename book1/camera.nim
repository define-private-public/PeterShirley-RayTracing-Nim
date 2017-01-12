import math
import vec3
import ray
import util


# Forward declrations
proc random_in_unit_disk(): vec3


type
  camera* = ref cameraObj
  cameraObj = object
    origin*, lower_left_corner*, horizontal*, vertical*: vec3
    u*, v*, w*: vec3
    lens_radius: float


proc newCamera*(lookfrom, lookat, vup: vec3, vfov, aspect, aperature, focus_dist: float): camera=
  result = camera()
  result.lens_radius = aperature / 2

  let
    theta = vfov * (PI / 180)
    half_height = tan(theta / 2)
    half_width = aspect * half_height

  result.origin = lookfrom
  result.w = unit_vector(lookfrom - lookat)
  result.u = unit_vector(vup.cross(result.w))
  result.v = result.w.cross(result.u)

  result.lower_left_corner = result.origin -
                             (half_width * focus_dist * result.u) -
                             (half_height * focus_dist * result.v) -
                             (focus_dist * result.w)
  result.horizontal = 2 * half_width * focus_dist * result.u
  result.vertical = 2 * half_height * focus_dist * result.v


proc get_ray*(c: camera, s, t: float): ray=
  let
    rd = c.lens_radius * random_in_unit_disk()
    offset = (c.u * rd.x) + (c.v * rd.y)

  return newRay(
    c.origin + offset,
    c.lower_left_corner + (s * c.horizontal) + (t * c.vertical) - c.origin - offset
  )


proc random_in_unit_disk(): vec3=
  var p = newVec3()

  # Note: Nim doesn't have built-in do-while loops, so we do this intead
  p = 2 * newVec3(drand48(), drand48(), 0) - newVec3(1, 1, 0)
  while dot(p, p) >= 1:
    p = 2 * newVec3(drand48(), drand48(), 0) - newVec3(1, 1, 0)

  return p

  
