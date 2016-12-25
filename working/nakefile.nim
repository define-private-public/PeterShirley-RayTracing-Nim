import os
import nake

const
  NimCache = "nimcache/"

  MainModuleName = "main.nim"
  BinaryName = "raytracer"
  BinaryOption = "-o:" & BinaryName
  SearchPath =  "--cincludes:."

  MonteCarloPi = "monte_carlo_pi.nim"
  MonteCarloPiBinaryOption = "-o:" & MonteCarloPi


task "debug", "Build in Debug mode":
  if shell(nimExe, "c", "-d:debug", SearchPath, BinaryOption, MainModuleName):
    echo("Debug built!")


task "release", "Build in Release mode":
  if shell(nimExe, "c", "-d:release", SearchPath, BinaryOption, MainModuleName):
    echo("Release built!")


task "monte_carlo_pi", "Monte Carlo Pi":
  if shell(nimExe, "c", "-d:release", MonteCarloPiBinaryOption, MonteCarloPi):
    echo("Monte Carlo Pi built!")


task "clean", "Clean up compiled output":
  removeDir(NimCache)
  removeFile(BinaryName)
  removeFile(MonteCarloPi)


task defaultTask, "[debug]":
  runTask("debug")

