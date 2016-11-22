import vec3
import ray


let renderToFile = true
var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


proc color(r: ray): vec3=
  let
    unit_direction = unit_vector(r.direction())
    t = 0.5 * (unit_direction.y + 1)

  return (1 - t) * newVec3(1, 1, 1) + t * newVec3(0.5, 0.7, 1)



proc main()=
  let
    nx = 200 * 3
    ny = 100 * 3

  output.write("P3\n", nx, " ", ny, "\n255\n")

  let
    lower_left_corner = newVec3(-2, -1, -1)
    horizontal = newVec3(4, 0, 0)
    vertical = newVec3(0, 2, 0)
    origin = newVec3(0, 0, 0)

  for j in countdown(ny - 1, 0):
    for i in countup(0, nx - 1):
      let
        u = i.float / nx.float
        v = j.float / ny.float
        r = newRay(origin, lower_left_corner + (u * horizontal) + (v * vertical))
        col = color(r)

        ir = (255.99 * col.r).int
        ig = (255.99 * col.g).int
        ib = (255.99 * col.b).int

      output.write(ir, " ", ig, " ", ib, "\n")


# Run Main method
main()

