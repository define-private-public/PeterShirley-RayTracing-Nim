import util
import math


proc pdf(x: float): float {.inline.} =
  return 0.5 * x


proc main()=
  var
    inside_circle = 0
    inside_circle_stratified = 0
    N = 1_000_000
    sum:float

  for i in countup(0, N - 1):
    let x = sqrt(2 * drand48())
    sum += (x * x) / pdf(x)

  echo("I = ", (sum / N.float))


main()

