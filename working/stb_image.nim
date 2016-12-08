# This file is a wrapper of a subset for the "stb_image.h" library that is
# needed for the raytracer

# Required before including the stb_image.h header
{.emit: """
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
""".}

# Internal function
proc stbi_load(filename: cstring; x, y, comp: var cint; req_comp: cint): ptr uint8
  {.importc: "stbi_load", noDecl.}

  # TODO use `cuchar` instead of `uint8` for that proc up there


## External function (the Nim friendly version)
# This will only load the RGB values, into a sequence of uint8 values
proc stbi_load*(filename: string; x, y, comp: var int; req_comp: int): seq[uint8] =
  # TODO need to free the image pixels after we've converted/copied

  var
    width: cint
    height: cint
    comp2: cint
    pixelData: seq[uint8]

  let data = stbi_load(filename.cstring, width, height, comp2, req_comp.cint)

  # Set the data
  x = width.int
  y = height.int
  comp = comp2.int

  # Copy it over
  newSeq(pixelData, x * y)
  copyMem(pixelData[0].addr, data, pixelData.len)

  return pixelData


