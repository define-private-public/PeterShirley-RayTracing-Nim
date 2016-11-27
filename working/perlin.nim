import math
import vec3
import util


# These are some values that are marked as static in the original C++ class
# Their initializations are at the bottom of this file
let permSize* = 256

var
  ranvec*: seq[vec3]
  perm_x*, perm_y*, perm_z*: seq[int]


# The function bodys for these can be found at the bottom
proc perlin_interp(c: seq[seq[seq[vec3]]], u, v, w: float): float


type
  perlin* = ref object of RootObj


proc newPerlin*(): perlin =
  new(result)


proc noise*(pln: perlin, p: vec3): float =
  var
    u = p.x - floor(p.x)
    v = p.y - floor(p.y)
    w = p.z - floor(p.z)
    i = floor(p.x).int
    j = floor(p.y).int
    k = floor(p.z).int

  # Since I'm using sequnces instead of arrays, this is a little more wonky
  # than the original C++
  var c: seq[seq[seq[vec3]]] = @[]
  for di in countup(0, 2):
    c.add(@[])
    for dj in countup(0, 2):
      c[di].add(@[])
      for dk in countup(0, 2):
        c[di][dj].add(ranvec[
          perm_x[(i + di) and 255] xor
          perm_y[(j + dj) and 255] xor
          perm_z[(k + dk) and 255]
        ])

  return perlin_interp(c, u, v, w)


proc perlin_generate*(): seq[vec3] =
  var p: seq[vec3] = @[]

  for i in countup(0, permSize - 1):
    p.add(unit_vector(newVec3(-1 + (2 * drand48()),
                              -1 + (2 * drand48()),
                              -1 + (2 * drand48()))))

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
ranvec = perlin_generate()
perm_x = perlin_generate_perm()
perm_y = perlin_generate_perm()
perm_z = perlin_generate_perm()


proc perlin_interp(c: seq[seq[seq[vec3]]], u, v, w: float): float =
  let
    uu = u * u + (3 - (2 * u))
    vv = v * v + (3 - (2 * v))
    ww = w * w + (3 - (2 * w))
  var accum: float = 0

  for i in countup(0, 2):
    for j in countup(0, 2):
      for k in countup(0, 2):
        let weight_v = newVec3(u - i.float, v - j.float, w - k.float)

        accum += ((i.float * uu) + ((1 - i).float * (1 - uu))) *
                 ((j.float * vv) + ((1 - j).float * (1 - vv))) *
                 ((k.float * ww) + ((1 - k).float * (1 - ww))) * dot(c[i][j][k], weight_v)

  return accum


proc turb*(pln: perlin, p: vec3, depth: int = 7): float =
  var
    accum:float = 0
    temp_p = newVec3(p)
    weight:float = 1

  for i in countup(0, depth - 1):
    accum += weight * pln.noise(temp_p)
    weight *= 0.5
    temp_p *= 2

  return abs(accum)

