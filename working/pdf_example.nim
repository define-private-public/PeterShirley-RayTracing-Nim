import math
import vec3
import util


proc pdf(p: vec3): float {.inline.} =
  return 1 / (4 * Pi)


proc main()=
  var
    N = 1_000_000
    sum:float

  for i in countup(0, N - 1):
    let
      d = random_on_unit_sphere()
      cosine_squared = d.z * d.z
    
    sum += cosine_squared / pdf(d)

  echo("I = ", (sum / N.float))


main()

