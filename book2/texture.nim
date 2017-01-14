import vec3


type
  texture* = ref textureObj
  textureObj* = object of RootObj


method value*(tex: texture, u, v: float, p: vec3): vec3 {.inline.} = 
  discard 

