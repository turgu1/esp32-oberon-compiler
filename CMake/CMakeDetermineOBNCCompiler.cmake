# Find the compiler
find_program(
    CMAKE_OBNC_COMPILER 
        NAMES "obnc-compile" 
        HINTS "${CMAKE_SOURCE_DIR}"
        DOC "OBNC compiler" 
)
mark_as_advanced(CMAKE_OBNC_COMPILER)

set(CMAKE_OBNC_SOURCE_FILE_EXTENSIONS Mod;MOD;mod;obe)
set(CMAKE_OBNC_OUTPUT_EXTENSION .c)
set(CMAKE_OBNC_COMPILER_ENV_VAR "OBNC")

# Configure variables set in this file for fast reload later on
configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeOBNCCompiler.cmake.in
               ${CMAKE_PLATFORM_INFO_DIR}/CMakeOBNCCompiler.cmake)
