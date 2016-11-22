import math
import random
import vec3
import ray
import hitable
import hitable_list
import sphere
import camera


randomize()


let renderToFile = true
var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


# Produced a random number between [0, 1)
proc drand48(): float=
  return 0
#  return random(1.0)


proc color(r: ray, world: hitable): vec3=
  var rec = newHitRecord()

  # TODO the 1 mil should be "MAXFLOAT" actually
  if world.hit(r, 0, 1_000_000, rec):
    return 0.5 * newVec3(rec.normal.x + 1, rec.normal.y + 1, rec.normal.z + 1)
  else:
    let
      unit_direction = unit_vector(r.direction())
      t = 0.5 * (unit_direction.y + 1)

    return (1 - t) * newVec3(1, 1, 1) + t * newVec3(0.5, 0.7, 1)


proc main()=
  let
    nx = 200 * 3
    ny = 100 * 3
    ns = 1

  output.write("P3\n", nx, " ", ny, "\n255\n")

  var list: seq[hitable] = @[]
  list.add(newSphere(newVec3(0, 0, -1), 0.5))
  list.add(newSphere(newVec3(0, -100.5, -1), 100))

  let
    world = newHitableList(list)
    cam = newCamera()

  for j in countdown(ny - 1, 0):
    for i in countup(0, nx - 1):
      var col = newVec3(0, 0, 0)

      # For antialiaising
      for s in countup(0, ns - 1):
        let
          u = (i.float + drand48()) / nx.float
          v = (j.float + drand48()) / ny.float
          r = cam.get_ray(u, v)
          p = r.point_at_parameter(2)
        
        col += color(r, world)

      # Average out
      col /= ns.float
      let
        ir = (255.99 * col.r).int
        ig = (255.99 * col.g).int
        ib = (255.99 * col.b).int

      output.write(ir, " ", ig, " ", ib, "\n")


# Run Main method
main()

# Cleanup if rendering to a file
if renderToFile:
  output.close()

