import math
import vec3
import ray
import hitable_and_material
import hitable_list
import sphere, moving_sphere, rects, flip_normals, box, translate, rotate_y, isotropic, constant_medium
import camera
import util
import lambertian, metal, dielectric, diffuse_light
import scenes
import aabb
import bvh_node
import texture, constant_texture, checker_texture, noise_texture, image_texture
import perlin
import stb_image
import cosine_pdf, hitable_pdf


let
  renderToFile = true
  maxDepth = 25

var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


proc color(r: ray, world: hitable, depth: int): vec3 =
  var rec = newHitRecord()

  if world.hit(r, 0.001, 1_000_000, rec):
    var
      scattered = newRay()
      attenuation = newVec3()
      emitted = rec.mat_ptr.emitted(r, rec, rec.u, rec.v, rec.p)
      pdf_val: float
      albedo: vec3

    if (depth < maxDepth) and (rec.mat_ptr.scatter(r, rec, albedo, scattered, pdf_val)):
      let
        light_shape = newXZRect(213, 343, 227, 332, 554, nil)
        p = newHitablePDF(light_shape, rec.p)

      scattered = newRay(rec.p, p.generate(), r.time)
      pdf_val = p.value(scattered.direction())

      return emitted + albedo * rec.mat_ptr.scattering_pdf(r, rec, scattered) * color(scattered, world, depth + 1) / pdf_val
    else:
      return emitted
  else:
    return newVec3(0, 0, 0)


proc main()=
  let
    nx = 500
    ny = 500
    ns = 10
#    nx = 1920
#    ny = 1080
#    ns = 250

  output.write("P3\n", nx, " ", ny, "\n255\n")

  var
    world: hitable
    cam: camera

  cornell_box(world, cam, nx.float / ny.float)

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

