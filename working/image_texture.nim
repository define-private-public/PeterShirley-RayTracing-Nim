import vec3
import texture


type
  image_texture* = ref object of texture
    data*: seq[uint8]
    nx*, ny*: int


proc newImageTexture*(): image_texture =
  new(result)
  result.data = @[]
  result.nx = 0
  result.ny = 0


proc newImageTexture*(pixels: seq[uint8]; A, B: int): image_texture =
  result = newImageTexture()
  result.data = pixels
  result.nx = A
  result.ny = B


method value*(ct: image_texture, u, v: float, p: vec3): vec3 =
  let
    i = u * nx
    j = ((1 - v) * ny) - 0.001

  i = i.clamp(0, nx - 1)
  j = j.clamp(0, ny - 1)

  let
    r = (data[(3 * i) + (3 * nx * j)]).float / 255.0
    g = (data[(3 * i) + (3 * nx * j) + 1]).float / 255.0
    b = (data[(3 * i) + (3 * nx * j) + 2]).float / 255.0

  return newVec3(r, g, b)

