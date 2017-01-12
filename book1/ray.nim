import vec3

type 
  ray* = object
    A*, B*: vec3


proc newRay*(): ray {.inline.} =
  return ray(A: newVec3(), B: newVec3())


proc newRay*(a, b: vec3): ray {.inline.} =
  return ray(A: a, B: b)


proc origin*(r: ray): vec3 {.inline.} =
  return r.A


proc direction*(r: ray): vec3 {.inline.} =
  return r.B


proc point_at_parameter*(r: ray, t: float): vec3 {.inline.} =
  return r.A + (t * r.B)

