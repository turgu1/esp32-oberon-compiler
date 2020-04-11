# CMAKE Definition to build the ESP32 Oberon Compiler
# STILL NOT A WORKING SOLUTION. Work in progress...

cmake_minimum_required(VERSION 3.5)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake")
enable_language(OBNC)

set(CMAKE_C_COMPILER "gcc")

project(OberonESP32 
  VERSION 0.2.0
  DESCRIPTION "ESP32 Oberon-07 Compiler"
  LANGUAGES OBNC C)

add_subdirectory(src)