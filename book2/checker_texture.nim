import math
import vec3
import texture, constant_texture


type
  checker_texture* = ref checker_textureObj
  checker_textureObj = object of textureObj
    odd*, even*: texture


# A little differnt from the book, by default make a black and white checker
proc newCheckerTexture*(): checker_texture =
  new(result)
  result.odd = newConstantTexture(newVec3(0, 0, 0))
  result.even = newConstantTexture(newVec3(1, 1, 1))


proc newCheckerTexture*(t0, t1: texture): checker_texture =
  result = newCheckerTexture()
  result.odd = t0
  result.even = t1


method value*(ct: checker_texture, u, v: float, p: vec3): vec3 =
  let sines = sin(10 * p.x) * sin(10 * p.y) * sin(10 * p.z)

  if sines < 0:
    return ct.odd.value(u, v, p)
  else:
    return ct.even.value(u, v, p)

