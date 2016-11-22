import vec3
import ray


let renderToFile = true
var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


proc hit_sphere(center: vec3, radius: float, r: ray): bool=
  let
    oc = r.origin() - center
    a = dot(r.direction(), r.direction())
    b = 2 * dot(oc, r.direction())
    c = dot(oc, oc) - (radius * radius)
    discriminant = (b * b) - (4 * a * c)

  return (discriminant > 0)


proc color(r: ray): vec3=
  if (hit_sphere(newVec3(0, 0, -1), 0.5, r)):
    return newVec3(1, 0, 0)

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

