# External build process for oberon, runs in source dir and produces liboberon.a
# ------------------------------------------------------------------------------
#
# The following prerequesite are needed to have Oberon programs properly linked
# with ESP-IDF:
#
# 1. The main application must call the external oberon_startup() function.
#
# 2. The oberon component must have the init.S assembly language function that
#    must contains the oberon_startup function. It is responsible of launching
#    all initialisation code present in each oberon module that is part of the
#    application (including the ones present in the liboberonesp32.a library)
#
# 3. The Makefile present in the current folder must be adjusted to identify
#    all oberon modules to be compiled.

idf_component_register()

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
# ------------------------------------
 
add_library(oberon STATIC IMPORTED GLOBAL)
add_dependencies(oberon oberon_build)

set_target_properties(oberon PROPERTIES IMPORTED_LOCATION ${COMPONENT_DIR}/liboberon.a)
set_target_properties(oberon PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${COMPONENT_DIR})

target_link_libraries(${COMPONENT_LIB} INTERFACE oberon)

set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${COMPONENT_DIR}/liboberon.a")

# Set OBERON_ESP32_LIB to the OberonESP32 compiler run-time library
# -----------------------------------------------------------------

find_library(OBERON_ESP32_LIB oberonesp32 /usr/local/lib/OberonESP32)
add_prebuilt_library(oberonesp32 ${OBERON_ESP32_LIB})
target_link_libraries(${COMPONENT_LIB} INTERFACE oberonesp32)

message("--->> OBERON_ESP32_LIB : ${OBERON_ESP32_LIB} <<---")
