import os
import nake

const
  NimCache = "nimcache/"

  MainModuleName = "main.nim"
  BinaryName = "raytracer"
  BinaryOption = "-o:" & BinaryName
  SearchPath =  "--cincludes:."

  MonteCarloPi = "monte_carlo_pi"
  MonteCarloPiBinaryOption = "-o:" & MonteCarloPi 

  PDFExample = "pdf_example"
  PDFExampleBinaryOption = "-o:" & PDFExample


task "debug", "Build in Debug mode":
  if shell(nimExe, "c", "-d:debug", SearchPath, BinaryOption, MainModuleName):
    echo("Debug built!")


task "release", "Build in Release mode":
  if shell(nimExe, "c", "-d:release", SearchPath, BinaryOption, MainModuleName):
    echo("Release built!")


task MonteCarloPi, "Monte Carlo Pi":
  let src = MonteCarloPi & ".nim"
  if shell(nimExe, "c", "-d:release", MonteCarloPiBinaryOption, src):
    echo("Monte Carlo Pi built!")

task PDFExample, "Probability Distribution Example":
  let src = PDFExample & ".nim"
  if shell(nimExe, "c", "-d:release",PDFExampleBinaryOption, src):
    echo("Probability Distribution Example built!")


task "clean", "Clean up compiled output":
  removeDir(NimCache)
  removeFile(BinaryName)
  removeFile(MonteCarloPi)


task defaultTask, "[debug]":
  runTask("debug")

