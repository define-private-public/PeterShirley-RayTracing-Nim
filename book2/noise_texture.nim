import math
import vec3
import texture
import perlin


type
  noise_texture* = ref noise_textureObj
  noise_textureObj = object of textureObj
    noise*: perlin
    scale*: float


proc newNoiseTexture*(): noise_texture =
  new(result)
  result.noise = newPerlin()
  result.scale = 0


proc newNoiseTexture*(sc: float): noise_texture =
  result = newNoiseTexture()
  result.scale = sc


method value*(nt: noise_texture, u, v: float, p: vec3): vec3 {.inline.} =
  # NOTE: This function has gone through many iterations in the book.  The fifth
  #       one should be used for the final scene, whereas the fourth should be
  #       used for `simple_light` and `two_perlin_spheres`

#  return newVec3(1, 1, 1) * nt.noise.noise(p)
#  return newVec3(1, 1, 1) * nt.noise.noise(nt.scale * p)
#  return newVec3(1, 1, 1) * nt.noise.turb(nt.scale * p)
#  return newVec3(1, 1, 1) * 0.5 * (1 + sin((nt.scale * p.z) + (10 * nt.noise.turb(p))))
  return newVec3(1, 1, 1) * 0.5 * (1 + sin((nt.scale * p.x) + (5 * nt.noise.turb(nt.scale * p))))

