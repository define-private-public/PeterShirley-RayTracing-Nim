import hitable_and_material
import vec3
import ray
import texture


type
  diffuse_light* = ref diffuse_lightObj
  diffuse_lightObj = object of materialObj
    emit*: texture


proc newDiffuseLight*(a: texture): diffuse_light=
  new(result)
  result.emit = a


method scatter*(
  dl: diffuse_light,
  r_in: ray,
  rec: hit_record,
  attenuation: var vec3,
  scattered: var ray
): bool {.inline.} =
  return false


method emitted*(dl: diffuse_light, u, v: float; p: vec3): vec3 {.inline.} =
  return dl.emit.value(u, v, p);

