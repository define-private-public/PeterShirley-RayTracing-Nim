import vec3
import texture
import perlin


type
  noise_texture* = ref object of texture
    noise*: perlin
    scale*: float


proc newNoiseTexture*(): noise_texture =
  new(result)
  result.noise = newPerlin()
  result.scale = 0


proc newNoiseTexture(sc: float): noise_texture =
  result = newNoiseTexture()
  result.scale = sc


method value*(nt: noise_texture, u, v: float, p: vec3): vec3 =
  return newVec3(1, 1, 1) * nt.noise.noise(nt.scale * p)

