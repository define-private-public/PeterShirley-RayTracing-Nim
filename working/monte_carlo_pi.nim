import util

proc main() =
  let N = 1000
  var inside_circle = 0
  
  for i in countup(0, N - 1):
    let
      x = 2 * drand48() - 1
      y = 2 * drand48() - 1

    if ((x * x) + (y * y)) < 1:
      inside_circle += 1

  echo "Estimate of Pi = ", (4 * inside_circle).float / N.float


main()

