import math
import vec3
import ray
import hitable_and_material
import hitable_list
import sphere
import camera
import util
import lambertian, metal, dielectric
import random_scene


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

    if (depth < maxDepth) and (rec.mat_ptr.scatter(r, rec, attenuation, scattered)):
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
    nx = 1200
    ny = 800
    ns = 10

  output.write("P3\n", nx, " ", ny, "\n255\n")

  var list: seq[hitable] = @[]
  list.add(newSphere(newVec3(0, 0, -1), 0.5, newLambertian(newVec3(0.1, 0.2, 0.5))))
  list.add(newSphere(newVec3(0, -100.5, -1), 100, newLambertian(newVec3(0.8, 0.8, 0))))
  list.add(newSphere(newVec3(1, 0, -1), 0.5, newMetal(newVec3(0.8, 0.6, 0.2), 1)))
  list.add(newSphere(newVec3(-1, 0, -1), 0.5, newDielectric(1.5)))
  list.add(newSphere(newVec3(-1, 0, -1), -0.45, newDielectric(1.5)))

  let
#    world = newHitableList(list)
    world = random_scene()

    lookfrom = newVec3(13, 2, 3)
    lookat = newVec3(0, 0, 0)
    dist_to_focus = 10.0
    aperature = 0.1

    cam = newCamera(
      lookfrom,
      lookat,
      newVec3(0, 1, 0),
      20,
      nx.float / ny.float,
      aperature,
      dist_to_focus
    )

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
        # NOTE: the extra `clamp()` call is added because there is a bug in the
        #       original source that would generate pixel values that were above
        #       255, which is highly incorrect
        ir = (255.99 * col.r).int.clamp(0, 255)
        ig = (255.99 * col.g).int.clamp(0, 255)
        ib = (255.99 * col.b).int.clamp(0, 255)

      output.write(ir, " ", ig, " ", ib, "\n")


# Run Main method
main()

# Cleanup if rendering to a file
if renderToFile:
  output.close()

