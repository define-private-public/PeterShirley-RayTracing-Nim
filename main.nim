import vec3


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
        col = newVec3(i.float / nx.float, j.float / ny.float, 0.2)
        ir = (255.99 * col.r).int
        ig = (255.99 * col.g).int
        ib = (255.99 * col.b).int

      output.write(ir, " ", ig, " ", ib, "\n")


# Run Main method
main()

