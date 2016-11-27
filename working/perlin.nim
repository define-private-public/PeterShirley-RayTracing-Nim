import math
import vec3
import util


# These are some values that are marked as static in the original C++ class
# Their initializations are at the bottom of this file
let permSize* = 256

var
  ranfloat*: seq[float]
  perm_x*, perm_y*, perm_z*: seq[int]


# The function body for this can be found at the bottom
proc trilinear_interp(c: seq[seq[seq[float]]], u, v, w: float): float


type
  perlin* = ref object of RootObj


proc newPerlin*(): perlin =
  new(result)


proc noise*(pln: perlin, p: vec3): float =
  let
    u = p.x - floor(p.x)
    v = p.y - floor(p.y)
    w = p.z - floor(p.z)
    i = floor(p.x).int
    j = floor(p.y).int
    k = floor(p.z).int

  # Since I'm using sequnces instead of arrays, this is a little more wonky
  # than the original C++
  var c: seq[seq[seq[float]]] = @[]
  for di in countup(0, 2):
    c.add(@[])
    for dj in countup(0, 2):
      c[di].add(@[])
      for dk in countup(0, 2):
        c[di][dj].add(ranfloat[
          perm_x[(i + di) and 255] xor
          perm_y[(j + dj) and 255] xor
          perm_z[(k + dk) and 255]
        ])

  return trilinear_interp(c, u, v, w)


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


proc trilinear_interp(c: seq[seq[seq[float]]], u, v, w: float): float =
  var accum: float = 0
  for i in countup(0, 2):
    for j in countup(0, 2):
      for k in countup(0, 2):
        accum += ((i.float * u) + ((1 - i.float) * (1 - u))) *
                 ((j.float * v) + ((1 - j.float) * (1 - v))) *
                 ((k.float * w) + ((1 - k.float) * (1 - w))) * c[i][j][k]

  return accum

