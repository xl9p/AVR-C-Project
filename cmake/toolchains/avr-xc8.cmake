# Microchip XC8 toolchain for AVR devices.
include("${CMAKE_CURRENT_LIST_DIR}/../avr-device.cmake")

set(AVR_XC8_ROOT "/opt/Microchip/xc8-v4.00" CACHE PATH
    "Root directory of the Microchip XC8 installation")
find_program(AVR_XC8_COMPILER
    NAMES xc8-cc
    HINTS "${AVR_XC8_ROOT}/bin"
    REQUIRED
)

set(AVR_XC8_AVR_DFP_DIR "${AVR_XC8_DEVICE_DIR}/avr")
set(AVR_XC8_DFP_INCLUDE_DIR "${AVR_XC8_AVR_DFP_DIR}/include")
set(AVR_XC8_DFP_LIB_DIR "${AVR_XC8_AVR_DFP_DIR}/lib")
foreach(path IN ITEMS "${AVR_XC8_DFP_INCLUDE_DIR}" "${AVR_XC8_DFP_LIB_DIR}")
    if(NOT IS_DIRECTORY "${path}")
        message(FATAL_ERROR
            "Required XC8 AVR DFP directory not found: ${path}\n"
            "Expected the AVR support tree under ${AVR_XC8_DEVICE_DIR}. "
            "Check the selected AVR-Dx DFP version.")
    endif()
endforeach()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# CMake has no built-in XC8 compiler module. Use its generic C compile/link
# rules and skip compiler-ID/ABI probes; xc8-cc remains the actual driver for
# every compile and link action. This means CMake cannot report XC8's built-in
# feature/ABI metadata, but it can generate ordinary C build rules.
set(CMAKE_C_COMPILER "${AVR_XC8_COMPILER}" CACHE FILEPATH "XC8 C compiler" FORCE)
set(CMAKE_C_COMPILER_ID "MicrochipXC8")
set(CMAKE_C_COMPILER_ID_RUN TRUE)
set(CMAKE_C_COMPILER_WORKS TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)

# The DFP option must be passed to the driver for both compilation and link.
# Quote the path in case the pack repository contains spaces.
set(_AVR_XC8_DEVICE_FLAGS
    "-mcpu=${AVR_MCU} -mdfp=${AVR_XC8_DEVICE_DIR}")
set(CMAKE_C_FLAGS_INIT "${_AVR_XC8_DEVICE_FLAGS}")


find_program(AVR_OBJCOPY NAMES avr-objcopy
    HINTS "${AVR_XC8_ROOT}/avr/bin" "${AVR_XC8_ROOT}/bin"
          "/usr/lib/avr/bin" REQUIRED)
find_program(AVR_OBJDUMP NAMES avr-objdump
    HINTS "${AVR_XC8_ROOT}/avr/bin" "${AVR_XC8_ROOT}/bin"
          "/usr/lib/avr/bin" REQUIRED)
find_program(AVR_SIZE NAMES avr-size
    HINTS "${AVR_XC8_ROOT}/avr/bin" "${AVR_XC8_ROOT}/bin"
          "/usr/lib/avr/bin" REQUIRED)

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
    AVR_XC8_ROOT
    AVR_XC8_COMPILER
)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
