import vec3
import texture
import perlin


type
  noise_texture* = ref object of texture
    noise*: perlin


proc newNoiseTexture*(): noise_texture =
  new(result)
  result.noise = newPerlin()


method value*(nt: noise_texture, u, v: float, p: vec3): vec3 =
  return newVec3(1, 1, 1) * nt.noise.noise(p)

