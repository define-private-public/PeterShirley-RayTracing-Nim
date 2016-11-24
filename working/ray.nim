import vec3

type 
  ray* = ref object of RootObj
    A*, B*: vec3
    time*: float


proc newRay*(): ray=
  return ray(A: newVec3(), B: newVec3(), time: 0)


proc newRay*(a, b: vec3, ti: float = 0): ray=
  return ray(A: a, B: b, time: ti)


proc origin*(r: ray): vec3=
  return r.A


proc direction*(r: ray): vec3=
  return r.B


proc point_at_parameter*(r: ray, t: float): vec3=
  return r.A + (t * r.B)

