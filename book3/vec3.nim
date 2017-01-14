import math


type
  vec3* = object
    x*, y*, z*: float


proc `$`*(v: vec3): string {.inline.} = 
  return $v.x & " " & $v.y & " " & $v.z


proc newVec3*(): vec3 {.inline.} =
  return vec3()


proc newVec3*(x, y, z: float): vec3 {.inline.} = 
  return vec3(x: x, y: y, z: z)


proc r*(v: vec3): float {.inline.} =
  return v.x


proc g*(v: vec3): float {.inline.} =
  return v.y


proc b*(v: vec3): float {.inline.} =
  return v.z


proc `+`*(v: vec3): vec3 {.inline.} =
  return v


proc `-`*(v: vec3): vec3 {.inline.} =
  return newVec3(-v.x, -v.y, -v.z)


proc `[]`*(v: vec3, i: int): float {.inline.} =
  case i
    of 0: return v.x
    of 1: return v.y
    of 2: return v.z
    else: raise newException(Exception, "Out of bounds")


proc `[]=`*(v: var vec3, i: int, value: float) {.inline.} =
  case i
    of 0: v.x = value
    of 1: v.y = value
    of 2: v.z = value
    else: raise newException(Exception, "Out of bounds")


proc squared_length*(v: vec3): float {.inline.} =
  return (v.x * v.x) + (v.y * v.y) + (v.z * v.z)


proc length*(v: vec3): float {.inline.} =
  return sqrt(squared_length(v))
 

proc make_unit_vector*(v: var vec3) {.inline.} =
  let k = 1 / v.length()

  v.x *= k
  v.y *= k
  v.z *= k


proc `+`*(u, v: vec3): vec3 {.inline.} =
  return newVec3(
    u.x + v.x,
    u.y + v.y,
    u.z + v.z
  )


proc `-`*(u, v: vec3): vec3 {.inline.} =
  return newVec3(
    u.x - v.x,
    u.y - v.y,
    u.z - v.z
  )


proc `*`*(u, v: vec3): vec3 {.inline.} =
  return newVec3(
    u.x * v.x,
    u.y * v.y,
    u.z * v.z
  )


proc `/`*(u, v: vec3): vec3 {.inline.} =
  return newVec3(
    u.x / v.x,
    u.y / v.y,
    u.z / v.z
  )


proc `*`*(s: float, v: vec3): vec3 {.inline.} =
  return newVec3(
    s * v.x,
    s * v.y,
    s * v.z
  )


proc `/`*(v: vec3, s: float): vec3 {.inline.} =
  return newVec3(
    v.x / s,
    v.y / s,
    v.z / s
  )


proc `*`*(v: vec3, s: float): vec3 {.inline.} =
  return newVec3(
    v.x * s,
    v.y * s,
    v.z * s
  )


proc dot*(u, v: vec3): float {.inline.} =
  return (u.x * v.x) + (u.y * v.y) + (u.z * v.z)


proc cross*(u, v: vec3): vec3 {.inline.} =
  return newVec3(
    (u.y * v.z) - (u.z * v.y),
    -((u.x * v.z) - (u.z * v.x)),
    (u.x * v.y) - (u.y * v.x)
  )


proc `+=`*(u: var vec3, v: vec3) {.inline.} =
  u.x += v.x
  u.y += v.y
  u.z += v.z


proc `*=`*(u: var vec3, v: vec3) {.inline.} =
  u.x *= v.x
  u.y *= v.y
  u.z *= v.z


proc `/=`*(u: var vec3, v: vec3) {.inline.} =
  u.x /= v.x
  u.y /= v.y
  u.z /= v.z


proc `-=`*(u: var vec3, v: vec3) {.inline.} =
  u.x -= v.x
  u.y -= v.y
  u.z -= v.z


proc `*=`*(v: var vec3, s:float) {.inline.} =
  v.x *= s 
  v.y *= s 
  v.z *= s 


proc `/=`*(v: var vec3, s:float) {.inline.} =
  let k = 1 / s

  v.x *= k 
  v.y *= k 
  v.z *= k 


proc unit_vector*(v: vec3): vec3 {.inline.} =
  return v / v.length()


# Reflect a vector about a normal
proc reflect*(v, n: vec3): vec3 {.inline.} =
  return v - (2 * v.dot(n) * n)


# Refract a vector about a normla (with a ratio)
proc refract*(v, n: vec3, ni_over_nt: float, refracted: var vec3): bool =
  let
    uv = v.unit_vector()
    dt = uv.dot(n)
    discriminant = 1 - (ni_over_nt * ni_over_nt * (1 - (dt * dt)))

  if discriminant > 0:
    refracted = (ni_over_nt * (uv - (n * dt))) - (n * sqrt(discriminant))
    return true
  else:
    return false


proc de_nan*(c: vec3):vec3 {.inline.} =
  var temp = c

  if temp[0] != temp[0]: temp[0] = 0
  if temp[1] != temp[1]: temp[1] = 0
  if temp[2] != temp[2]: temp[2] = 0

  return temp

