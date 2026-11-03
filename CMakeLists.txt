cmake_minimum_required(VERSION 3.20)

project(firmware LANGUAGES C)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Sources
set(AVR_SOURCES
    src/main.c
)

add_executable(firmware ${AVR_SOURCES})

add_subdirectory(lib)
target_link_libraries(firmware PRIVATE testlib)
# ----------


set(AVR_IMAGE_NAME "firmware" CACHE STRING "Output image basename")
set(AVR_OUTPUT_DIR "${CMAKE_BINARY_DIR}/out")
set(AVR_MAP_FILE "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.map")

set_target_properties(firmware PROPERTIES
    OUTPUT_NAME "${AVR_IMAGE_NAME}"
    SUFFIX ".elf"
    RUNTIME_OUTPUT_DIRECTORY "${AVR_OUTPUT_DIR}"
)

# Device-register headers and other device-specific headers from the DFP.
target_include_directories(firmware PRIVATE "${AVR_DFP_INCLUDE_DIR}")

# Additional flags that may affect ABI
option(AVR_MPLAB_ABI_FLAGS
    "Use the ABI-affecting flags from the supplied MPLAB AVR rules" ON)

target_compile_options(firmware PRIVATE
    "$<$<AND:$<CONFIG:Debug>,$<COMPILE_LANGUAGE:C,CXX>>:-Og>"
    "$<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:-gdwarf-2>"
    "$<$<AND:$<CONFIG:Release>,$<COMPILE_LANGUAGE:C,CXX>>:-Os>"
    "$<$<AND:$<CONFIG:RelWithDebInfo>,$<COMPILE_LANGUAGE:C,CXX>>:-Os>"

    -ffunction-sections
    -fdata-sections
    -Wall
    -Wextra
    -pedantic
    -pedantic-errors
)

if(AVR_MPLAB_ABI_FLAGS)
    target_compile_options(firmware PRIVATE
        "$<$<COMPILE_LANGUAGE:C,CXX>:-funsigned-char>"
        "$<$<COMPILE_LANGUAGE:C,CXX>:-funsigned-bitfields>"
        "$<$<COMPILE_LANGUAGE:C,CXX>:-fpack-struct>"
        "$<$<COMPILE_LANGUAGE:C,CXX>:-fshort-enums>"
    )
endif()


target_link_options(firmware PRIVATE
    "-Wl,-Map=${AVR_MAP_FILE}"
    -Wl,--gc-sections
)

set(AVR_POST_BUILD_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/cmake/avr-post-build.cmake")
set(AVR_ELF "$<TARGET_FILE:firmware>")
set(AVR_OUTPUTS
    "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.hex"
    "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.eep"
    "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.srec"
    "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.usersignatures"
    "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.lss"
    "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}.mem"
)

add_custom_command(TARGET firmware POST_BUILD
    COMMAND "${CMAKE_COMMAND}"
    "-DAVR_OBJCOPY=${AVR_OBJCOPY}"
    "-DAVR_OBJDUMP=${AVR_OBJDUMP}"
    "-DAVR_SIZE=${AVR_SIZE}"
    "-DAVR_ELF=${AVR_ELF}"
    "-DAVR_OUTPUT_DIR=${AVR_OUTPUT_DIR}"
    "-DAVR_IMAGE_NAME=${AVR_IMAGE_NAME}"
    -P "${AVR_POST_BUILD_SCRIPT}"
    BYPRODUCTS ${AVR_OUTPUTS}
    VERBATIM
    COMMENT "Generating AVR image formats and reports"
)
