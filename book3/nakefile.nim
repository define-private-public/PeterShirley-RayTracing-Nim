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

  RandomCosineTest = "random_cosine_test"
  RandomCosineTestBinaryOption = "-o:" & RandomCosineTest


task "debug", "Build in Debug mode":
  if direShell(nimExe, "c", "-d:debug", SearchPath, BinaryOption, MainModuleName):
    echo("Debug built!")


task "release", "Build in Release mode":
  if direShell(nimExe, "c", "-d:release", SearchPath, BinaryOption, MainModuleName):
    echo("Release built!")


task MonteCarloPi, "Monte Carlo Pi":
  let src = MonteCarloPi & ".nim"
  if direShell(nimExe, "c", "-d:release", MonteCarloPiBinaryOption, src):
    echo("Monte Carlo Pi built!")


task PDFExample, "Probability Distribution Example":
  let src = PDFExample & ".nim"
  if direShell(nimExe, "c", "-d:release", PDFExampleBinaryOption, src):
    echo("Probability Distribution Example built!")


task RandomCosineTest, "Random Cosine Direction Test":
  let src = RandomCosineTest & ".nim"
  if direShell(nimExe, "c", "-d:release", RandomCosineTestBinaryOption, src):
    echo("Random Cosine Direction Test built!")


task "clean", "Clean up compiled output":
  removeDir(NimCache)
  removeFile(BinaryName)
  removeFile(MonteCarloPi)


task defaultTask, "[debug]":
  runTask("debug")

