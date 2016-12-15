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


let
  renderToFile = true
  maxDepth = 25

var output:File

# Render to either "render.ppm," or to STDout
if renderToFile:
  discard open(output, "render.ppm", fmReadWrite)
else:  
  output = stdout


# There are two different color functions that can be used to illuminate the
# scene.  They can be swapped out below with the `color` proc

# This proc is for if you scene is illuminated ambiently (no diffuse lighting)
proc color_with_ambient(r: ray, world: hitable, depth: int): vec3 =
  var rec = newHitRecord()

  # the 1 mil should be "MAXFLOAT" actually
  if world.hit(r, 0.001, 1_000_000, rec):
    var
      scattered = newRay()
      attenuation = newVec3()

    if (depth < maxDepth) and (rec.mat_ptr.scatter(r, rec, attenuation, scattered)):
      return attenuation * color_with_ambient(scattered, world, depth + 1)
    else:
      return newVec3(0, 0, 0)
  else:
    let
      unit_direction = r.direction().unit_vector
      t = 0.5 * (unit_direction.y + 1)

    return ((1 - t) * newVec3(1, 1, 1)) + (t * newVec3(0.5, 0.7, 1))


# this proc is for if you scene contains lights (it will render black without)
proc color_with_lights(r: ray, world: hitable, depth: int): vec3 =
  var rec = newHitRecord()

  # the 1 mil should be "MAXFLOAT" actually
  if world.hit(r, 0.001, 1_000_000, rec):
    var
      scattered = newRay()
      attenuation = newVec3()
      emitted = rec.mat_ptr.emitted(rec.u, rec.v, rec.p)

    if (depth < maxDepth) and (rec.mat_ptr.scatter(r, rec, attenuation, scattered)):
      return emitted + (attenuation * color_with_lights(scattered, world, depth + 1))
    else:
      return emitted
  else:
    return newVec3(0, 0, 0)


# NOTE: this is the proc that you swap out with one of the two above for your
#       desired method of illumination
proc color(r: ray, world: hitable, depth: int): vec3 {.inline.} =
  return color_with_ambient(r, world, depth)


proc main()=
  let
    nx = 400 
    ny = 400
    ns = 16
#    nx = 1920
#    ny = 1080
#    ns = 250

  output.write("P3\n", nx, " ", ny, "\n255\n")

  let
#    world = original_scene()
    world = random_scene()
#    world = two_spheres()
#    world = two_perlin_spheres()
#    world = earth()
#    world = simple_light()
#    world = cornell_box()
#    world = cornell_smoke()
#    world = final()

    cam = random_scene_cam(nx, ny)

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

