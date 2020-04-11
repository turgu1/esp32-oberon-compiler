# CMAKE Definition to build the ESP32 Oberon Compiler
# STILL NOT A WORKING SOLUTION. Work in progress...

cmake_minimum_required(VERSION 3.5)

add_executable(OberonESP32 
  SYS.c
  SYS.sym
  SYS.h
  Texts.Mod
  ORS.Mod
  ORB.Mod
  ORG.Mod
  ORP.Mod
  Oberon.Mod
)

set_source_files_properties(SYS.c 
  PROPERTIES COMPILE_FLAGS -I/usr/local/include)

configure_file(SYS.sym .obnc/SYS.sym COPYONLY)
configure_file(SYS.h .obnc/SYS.h COPYONLY)
