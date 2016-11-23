import os
import nake

const
  NimCache = "nimcache/"

  MainModuleName = "main"
  BinaryName = "raytracer"
  BinaryOption = "-o:" & BinaryName


task "debug", "Build in Debug mode":
  if shell(nimExe, "c", "-d:debug", BinaryOption, MainModuleName):
    echo("Debug built!")


task "release", "Build in Release mode":
  if shell(nimExe, "c", "-d:release", BinaryOption, MainModuleName):
    echo("Release built!")


task "clean", "Clean up compiled output":
  removeDir(NimCache)
  removeFile(BinaryName)


task defaultTask, "[debug]":
  runTask("debug")

