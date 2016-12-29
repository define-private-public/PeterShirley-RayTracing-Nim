import vec3


type
  pdf* = object of RootObj


method value*(p: pdf; direction: vec3):float {.base.} =
  raise newException(Exception, "pdf::value() is a pure virtual method")


method generate*(p: pdf):vec3 {.base.} =
  raise newException(Exception, "pdf::generate() is a pure virtual method")

