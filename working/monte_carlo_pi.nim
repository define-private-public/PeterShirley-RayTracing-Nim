import util

proc main() =
  let sqrt_N = 1000
  var
    inside_circle = 0
    inside_circle_stratified = 0
 
  for i in countup(0, sqrt_N - 1):
    for j in countup(0, sqrt_N - 1):
      var 
        x = 2 * drand48() - 1
        y = 2 * drand48() - 1

      if ((x * x) + (y * y)) < 1:
        inside_circle += 1

      x = 2 * ((i.float + drand48()) / sqrt_N.float) - 1
      y = 2 * ((j.float + drand48()) / sqrt_N.float) - 1

      if ((x * x) + (y * y)) < 1:
        inside_circle_stratified += 1

  echo "Regular    Estimate of Pi = ", (4 * inside_circle).float / (sqrt_N * sqrt_N).float
  echo "Stratified Estimate of Pi = ", (4 * inside_circle_stratified).float / (sqrt_N * sqrt_N).float


main()

