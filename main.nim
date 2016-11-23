import math
import random
import vec3
import ray
import hitable_and_material
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
  return random(1.0)


proc random_in_unit_sphere(): vec3=
  var p = newVec3()

  # Note: Nim doesn't have built-in do-while loops, so we do this intead
  p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)
  while p.squared_length() > 1:
    p = 2 * newVec3(drand48(), drand48(), drand48()) - newVec3(1, 1, 1)

  return p


proc color(r: ray, world: hitable): vec3=
  var rec = newHitRecord()

  # TODO the 1 mil should be "MAXFLOAT" actually
  if world.hit(r, 0, 1_000_000, rec):
    let target = rec.p + rec.normal + random_in_unit_sphere()
    return 0.5 * color(newRay(rec.p, target - rec.p), world)
  else:
    let
      unit_direction = unit_vector(r.direction())
      t = 0.5 * (unit_direction.y + 1)

    return (1 - t) * newVec3(1, 1, 1) + t * newVec3(0.5, 0.7, 1)


proc main()=
  let
    nx = 200 * 3
    ny = 100 * 3
    ns = 8

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

      col = newVec3(sqrt(col.x), sqrt(col.y), sqrt(col.z))
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


# Testing to see if it's fine
var
  m = newMaterial()
  hr = newHitRecord()

hr.mat_ptr = m.addr
