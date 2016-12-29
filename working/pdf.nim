import vec3


type
  pdf* = object


method value*(p: pdf; direction: vec3):float {.base.} =
  return 0


method generate*(p: pdf):vec3 {.base.} =
  return newVec3()

