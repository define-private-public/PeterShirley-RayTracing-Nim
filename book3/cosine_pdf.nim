import pdf
import vec3
import onb
import util
from math import Pi


type
  cosine_pdf* = ref cosine_pdfObj
  cosine_pdfObj = object of pdfObj
    uvw*: onb


proc newCosinePDF*(w: vec3):cosine_pdf =
  result = cosine_pdf()
  result.uvw.build_From_w(w)


method value*(cPDF: cosine_pdf; direction: vec3): float {.inline.} =
  let cosine = dot(unit_vector(direction), cPDF.uvw.w)

  if cosine > 0:
    return cosine / Pi
  else:
    return 0


method generate*(cPDF: cosine_pdf): vec3 {.inline.} =
  return cPDF.uvw.local(random_cosine_direction())

