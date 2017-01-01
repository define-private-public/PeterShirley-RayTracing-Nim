import vec3


type
  texture* = ref object of RootObj


method value*(tex: texture, u, v: float, p: vec3): vec3 =
  discard 

