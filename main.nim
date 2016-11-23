import math
import vec3
import ray
import hitable_and_material
import hitable_list
import sphere
import camera
import util
import lambertian, metal


let
  renderToFile = true
  maxDepth = 50

var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


proc color(r: ray, world: hitable, depth: int): vec3=
  var rec = newHitRecord()

  # TODO the 1 mil should be "MAXFLOAT" actually
  if world.hit(r, 0.001, 1_000_000, rec):
    var
      scattered = newRay()
      attenuation = newVec3()

    let
      a = depth < maxDepth
      b = rec.mat_ptr.scatter(r, rec, attenuation, scattered)

    if a and b:
      return attenuation * color(scattered, world, depth + 1)
    else:
      return newVec3(0, 0, 0)
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
  list.add(newSphere(newVec3(0, 0, -1), 0.5, newLambertian(newVec3(0.8, 0.3, 0.3))))
  list.add(newSphere(newVec3(0, -100.5, -1), 100, newLambertian(newVec3(0.8, 0.8, 0))))
#  list.add(newSphere(newVec3(1, 0, -1), 0.5, newMetal(newVec3(0.8, 0.6, 0.2))))
#  list.add(newSphere(newVec3(-1, 0, -1), 0.5, newMetal(newVec3(0.8, 0.8, 0.8))))

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
        
        col += color(r, world, 0)

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

