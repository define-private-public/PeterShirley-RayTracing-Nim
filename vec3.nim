import math


type
  vec3* = ref object of RootObj
    x*, y*, z*: float


proc `$`*(v: vec3): string = 
  return "<" & $v.x & ", " & $v.y & ", " & $v.z & ">"


proc newVec3*(x, y, z: float): vec3 = 
  return vec3(x: x, y: y, z: z)


proc r*(v: vec3): float =
  return v.x


proc g*(v: vec3): float =
  return v.g


proc b*(v: vec3): float =
  return v.b


proc `+`*(v: vec3): vec3 =
  return v


proc `-`*(v: vec3): vec3 =
  return newVec3(-v.x, -v.y, -v.z)


proc `[]`*(v: vec3, i: int): float =
  case i
    of 0: return v.x
    of 1: return v.y
    of 2: return v.z
    else: raise newException(Exception, "Out of bounds")


proc `[]=`*(v: vec3, i: int, value: float)=
  case i
    of 0: v.x = value
    of 1: v.y = value
    of 2: v.z = value
    else: raise newException(Exception, "Out of bounds")


proc squared_length*(v: vec3): float =
  return (v.x * v.x) + (v.y * v.y) + (v.z * v.z)


proc length*(v: vec3): float =
  return sqrt(squared_length(v))
  


#proc `+`(u, v: vec3): vec3 =
#  return newVec3(
#    u.x + v.x,
#    u.y + v.y,
#    u.z + v.z
#  )
#
#
#proc `-`(u, v: vec3): vec3 =
#  return newVec3(
#    u.x - v.x,
#    u.y - v.y,
#    u.z - v.z
#  )
