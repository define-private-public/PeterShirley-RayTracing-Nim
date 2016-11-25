import math
import vec3
import ray
import hitable_and_material
import hitable_list
import sphere, moving_sphere
import camera
import util
import lambertian, metal, dielectric
import scenes
import aabb
import bvh_node
import texture, constant_texture, checker_texture


let
  renderToFile = true
  maxDepth = 25

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
    nx = 200 * 2
    ny = 100 * 2
    ns = 4

  output.write("P3\n", nx, " ", ny, "\n255\n")

  let
#    world = original_scene()
#    world = random_scene()
    world = two_spheres()

    lookfrom = newVec3(13, 2, 3)
    lookat = newVec3(0, 0, 0)
    dist_to_focus = 10.0
    aperature = 0.0

    cam = newCamera(
      lookfrom,
      lookat,
      newVec3(0, 1, 0),
      20,
      nx.float / ny.float,
      aperature,
      dist_to_focus,
      0, 1
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
        ir = (255.99 * col.r).int
        ig = (255.99 * col.g).int
        ib = (255.99 * col.b).int

      output.write(ir, " ", ig, " ", ib, "\n")


# Run Main method
main()

# Cleanup if rendering to a file
if renderToFile:
  output.close()

