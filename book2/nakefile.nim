import os
import nake

const
  NimCache = "nimcache/"

  MainModuleName = "main.nim"
  BinaryName = "raytracer"
  BinaryOption = "-o:" & BinaryName
  SearchPath =  "--cincludes:."


task "debug", "Build in Debug mode":
  if direShell(nimExe, "c", "-d:debug", SearchPath, BinaryOption, MainModuleName):
    echo("Debug built!")


task "release", "Build in Release mode":
  if direShell(nimExe, "c", "-d:release", SearchPath, BinaryOption, MainModuleName):
    echo("Release built!")


task "clean", "Clean up compiled output":
  removeDir(NimCache)
  removeFile(BinaryName)


task defaultTask, "[debug]":
  runTask("debug")

