import vec3
import texture


type
  image_texture* = ref image_textureObj
  image_textureObj = object of textureObj
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


method value*(it: image_texture, u, v: float, p: vec3): vec3 =
  var
    i = (u * it.nx.float).int
    j = (((1 - v) * it.ny.float) - 0.001).int

  i = i.clamp(0, it.nx - 1)
  j = j.clamp(0, it.ny - 1)

  let
    r = (it.data[3*i + 3*it.nx*j + 0]).float / 255.0
    g = (it.data[3*i + 3*it.nx*j + 1]).float / 255.0
    b = (it.data[3*i + 3*it.nx*j + 2]).float / 255.0
    

  return newVec3(r, g, b)

