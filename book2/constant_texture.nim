import vec3
import texture


type
  constant_texture* = ref constant_textureObj
  constant_textureObj = object of textureObj
    color*: vec3


proc newConstantTexture*(): constant_texture =
  new(result)
  result.color = newVec3()


proc newConstantTexture*(c: vec3): constant_texture =
  result = newConstantTexture()
  result.color = c


method value*(ct: constant_texture, u, v: float, p: vec3): vec3 {.inline.} =
  return ct.color

