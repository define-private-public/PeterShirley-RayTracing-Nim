import pdf
import vec3
import util


type
  mixture_pdf* = ref mixture_pdfObj
  mixture_pdfObj = object of pdfObj
    p*: array[2, pdf]


proc newMixturePDF*(p0, p1: pdf):mixture_pdf =
  result = mixture_pdf()
  result.p[0] = p0
  result.p[1] = p1


method value*(mPDF: mixture_pdf; direction: vec3): float {.inline.} =
  return (0.5 * mPDF.p[0].value(direction)) + (0.5 * mPDF.p[1].value(direction))


method generate*(mPDF: mixture_pdf): vec3 {.inline.} =
  if drand48() < 0.5:
    return mPDF.p[0].generate()
  else:
    return mPDF.p[1].generate()

