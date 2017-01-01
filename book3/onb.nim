import math
import vec3


type
  onb* = object
    axis*:array[3, vec3]


proc newONB*(): onb =
  return onb()


proc `[]`*(o: onb, i: int): vec3 =
  return o.axis[i]


proc u*(o: onb): vec3 =
  return o.axis[0]


proc v*(o: onb): vec3 =
  return o.axis[1]


proc w*(o: onb): vec3 =
  return o.axis[2]


proc local*(o: onb; a, b, c: float): vec3 =
  return (a * o.u) + (b * o.v) + (c * o.w)


proc local*(o: onb; a: vec3): vec3 =
  return (a.x * o.u) + (a.y * o.v) + (a.z * o.w)


proc build_from_w*(o: var onb; n: vec3) =
  o.axis[2] = n.unit_vector
  var a:vec3

  if abs(o.w().x) > 0.9:
    a = newVec3(0, 1, 0)
  else:
    a = newVec3(1, 0, 0)

  o.axis[1] = unit_vector(cross(o.w, a))
  o.axis[0] = cross(o.w, o.v)

