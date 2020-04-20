# External build process for oberon, runs in source dir and produces liboberon.a

idf_component_register()

set(OBERON_ESP32_LIB, /usr/local/lib/liboberonesp32.lib)

ExternalProject_Add(oberon_build
    PREFIX ${COMPONENT_DIR}
    BINARY_DIR ${COMPONENT_DIR}
    TMP_DIR ${COMPONENT_DIR}/build/tmp
    STAMP_DIR ${COMPONENT_DIR}/build/stamp
    SOURCE_DIR ${COMPONENT_DIR}/src
    BUILD_BYPRODUCTS ${COMPONENT_DIR}/liboberon.a
    BUILD_ALWAYS 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make liboberon.a
    INSTALL_COMMAND ""
    )

# Add liboberon.a to the build process
 
add_library(oberon STATIC IMPORTED GLOBAL)
add_dependencies(oberon oberon_build)

set_target_properties(oberon PROPERTIES IMPORTED_LOCATION
     ${COMPONENT_DIR}/liboberon.a)

set_target_properties(oberon PROPERTIES INTERFACE_INCLUDE_DIRECTORIES
     ${COMPONENT_DIR})

target_link_libraries(${COMPONENT_LIB} INTERFACE oberon)

set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES
     "${COMPONENT_DIR}/liboberon.a")
