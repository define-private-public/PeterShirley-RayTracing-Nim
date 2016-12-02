import hitable_and_material
import vec3
import ray
import aabb


type
  constant_medium* = ref object of hitable
    boundary*: hitable
    density*: float
    phase_function*: material


#proc newConstantMedium*(b: hitable, d: float, a: texture)
