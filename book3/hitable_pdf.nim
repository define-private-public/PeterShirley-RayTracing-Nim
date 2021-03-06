import pdf
import vec3
import hitable_and_material


type
  hitable_pdf* = ref object of pdf
    o*: vec3
    obj*: hitable


proc newHitablePDF*(p: hitable; origin: vec3):hitable_pdf =
  result = hitable_pdf(
    o: origin,
    obj: p
  )


method value*(hPDF: hitable_pdf; direction: vec3):float =
  return hPDF.obj.pdf_value(hPDF.o, direction)


method generate*(hPDF: hitable_pdf):vec3 =
  return hPDF.obj.random(hPDF.o)

