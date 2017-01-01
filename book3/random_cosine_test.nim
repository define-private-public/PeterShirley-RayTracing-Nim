import math
import vec3
import util


proc main() =
  let N = 1_000_000
  var sum:float

  for i in 0..<N:
    let v = random_cosine_direction()
    sum += (v.z * v.z * v.z) / (v.z / Pi)

  echo "PI/2 = ", (Pi / 2)
  echo "Estimate = ", (sum / N.float)


main()

