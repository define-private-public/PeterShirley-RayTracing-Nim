

let renderToFile = true
var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


proc main()=
  let
    nx = 200
    ny = 100

  output.write("P3\n", nx, " ", ny, "\n255\n")
  for j in countdown(ny - 1, 0):
    for i in countup(0, nx - 1):
      let
        r = i.float / nx.float
        g = j.float / ny.float
        b = 0.2
        ir = (255.99*r).int
        ig = (255.99*g).int
        ib = (255.99*b).int

      output.write(ir, " ", ig, " ", ib, "\n")


# Run Main method
main()


