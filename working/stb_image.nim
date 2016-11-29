# This file is a wrapper of a subset for the "stb_image.h" library that is
# needed for the raytracer

# Required before including the stb_image.h header
{.emit: """
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
""".}

# Internal function
proc stbi_load(filename: cstring; x, y, comp: var cint; req_comp: cint): cstring
  {.importc: "stbi_load", noDecl.}


## External function (the Nim friendly version)
proc stbi_load*(filename: string; x, y, comp: var int; req_comp: int): seq[uint8] =
  var
    width: cint
    height: cint
    comp2: cint
    pixelData: seq[uint8]

  let data = stbi_load(filename.cstring, width, height, comp2, req_comp.cint)

  # Set the data
  x = width.int
  y = width.int
  comp = comp2.int

  echo x, " ", y, " ", comp

  newSeq(pixelData, x * y)
  # TODO set the pixelData

  return pixelData


