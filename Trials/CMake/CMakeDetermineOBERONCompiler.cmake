# Find the compiler
find_program(
    CMAKE_OBERON_COMPILER 
        NAMES "OberonESP32" 
        HINTS "${CMAKE_SOURCE_DIR}"
        DOC "Oberon ESP32 Compiler" 
)

mark_as_advanced(CMAKE_OBERON_COMPILER)

set(CMAKE_OBERON_SOURCE_FILE_EXTENSIONS Mod;mod;MOD;Obe;obe;OBE)
set(CMAKE_OBERON_OUTPUT_EXTENSION .o)
set(CMAKE_OBERON_COMPILER_ENV_VAR "OberonESP32")

# Configure variables set in this file for fast reload later on
configure_file(${CMAKE_CURRENT_LIST_DIR}/CMakeOBERONCompiler.cmake.in
               ${CMAKE_PLATFORM_INFO_DIR}/CMakeOBERONCompiler.cmake)
