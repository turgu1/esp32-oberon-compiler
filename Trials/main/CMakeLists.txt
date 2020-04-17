if(NOT CMAKE_OBERON_COMPILE_OBJECT)
    MESSAGE("Defining CMAKE_OBERON_COMPILE_OBJECT")
    set(CMAKE_OBERON_COMPILE_OBJECT 
           "<CMAKE_OBERON_COMPILER> -s <SOURCE> -o <CMAKE_CURRENT_BINARY_DIR>")
endif()

set(srcs "app_main.c" "init.S" "Main.Mod" "Out.Mod")

idf_component_register(
    SRCS "${srcs}"
    INCLUDE_DIRS "")

set_source_files_properties(init.S PROPERTIES COMPILE_FLAGS -mtext-section-literals)
