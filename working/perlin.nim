import math
import vec3
import util


# These are some values that are marked as static in the original C++ class
# Their initializations are at the bottom of this file
let permSize* = 256

var
  ranfloat*: seq[float]
  perm_x*, perm_y*, perm_z*: seq[int]



type
  perlin* = ref object of RootObj


proc newPerlin*(): perlin =
  new(result)


proc noise*(pln: perlin, p: vec3): float =
  let
    u = p.x - floor(p.x)
    v = p.y - floor(p.y)
    w = p.z - floor(p.z)
    i = (4 * p.x).int and 255
    j = (4 * p.y).int and 255
    k = (4 * p.z).int and 255

  return ranfloat[perm_x[i] xor perm_y[j] xor perm_z[k]]


proc perlin_generate*(): seq[float] =
  var p: seq[float] = @[]

  for i in countup(0, permSize - 1):
    p.add(drand48())

  return p


# Because we're using sequnces, the parameters for this funciton are differnt
proc permute*(p: var seq[int])=
  for i in countdown(p.len - 1, 0):
    let
      target = (drand48() * (i + 1).float).int
      tmp = p[i]

    p[i] = p[target]
    p[target] = tmp


proc perlin_generate_perm*(): seq[int] =
  var p: seq[int] = @[]

  for i in countup(0, permSize - 1):
    p.add(i)

  permute(p)
  return p


# Init the "statics"
ranfloat = perlin_generate()
perm_x = perlin_generate_perm()
perm_y = perlin_generate_perm()
perm_z = perlin_generate_perm()

