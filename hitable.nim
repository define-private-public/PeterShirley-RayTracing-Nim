import vec3
import ray


type
  hit_record* = ref object of RootObj
    t*: float
    p*, normal*: vec3


  hitable* = ref object of RootObj


method hit*(h: hitable, r: ray, t_min, t_max: float, var rect: hit_record)=
  discard

