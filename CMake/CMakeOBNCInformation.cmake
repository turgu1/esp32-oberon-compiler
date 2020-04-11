# This file sets the basic flags for the OBNC compiler
if(NOT CMAKE_OBNC_COMPILE_OBJECT)
    set(CMAKE_OBNC_COMPILE_OBJECT 
           "<CMAKE_OBNC_COMPILER> <SOURCE>"
            "<CMAKE_C_COMPILER> <OBJECT>")
endif()
set(CMAKE_OBNC_INFORMATION_LOADED 1)