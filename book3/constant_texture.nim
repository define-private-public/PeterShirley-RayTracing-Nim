import vec3
import texture


type
  constant_texture* = ref object of texture
    color*: vec3


proc newConstantTexture*(): constant_texture =
  new(result)
  result.color = newVec3()


proc newConstantTexture*(c: vec3): constant_texture =
  result = newConstantTexture()
  result.color = c


method value*(ct: constant_texture, u, v: float, p: vec3): vec3 =
  return ct.color

