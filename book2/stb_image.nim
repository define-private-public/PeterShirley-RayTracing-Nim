# This file is a wrapper of a subset for the "stb_image.h" library that is
# needed for the raytracer.
#
# Check out https://gitlab.com/define-private-public/stb_image-Nim for a more
# robust one.

# Required before including the stb_image.h header
{.emit: """
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
""".}



# Internal functions
proc stbi_image_free(terval_from_stbi_load: ptr)
  {.importc: "stbi_image_free", noDecl.}

proc stbi_load(filename: cstring; x, y, comp: var cint; req_comp: cint): ptr cuchar 
  {.importc: "stbi_load", noDecl.}



## External function (the Nim friendly version)
# This will only load the RGB values, into a sequence of uint8 values
proc stbi_load*(filename: string; x, y, comp: var int; req_comp: int): seq[uint8] =
  # TODO need to free the image pixels after we've converted/copied
  var
    width: cint
    height: cint
    channels: cint
    pixelData: seq[uint8]

  let data = stbi_load(filename.cstring, width, height, channels, req_comp.cint)

  # Set the data
  x = width.int
  y = height.int
  comp = channels.int

  # Copy it over
  newSeq(pixelData, x * y * comp)
  copyMem(pixelData[0].addr, data, pixelData.len)

  # Free leftovers
  stbi_image_free(data)

  # Return the seuquence
  return pixelData


