# GNU GCC toolchain for AVR devices.
include("${CMAKE_CURRENT_LIST_DIR}/../avr-device.cmake")

if(NOT IS_DIRECTORY "${AVR_GCC_DEVICE_DIR}")
    message(FATAL_ERROR
        "Required AVR-GCC device support not found: ${AVR_GCC_DEVICE_DIR}\n"
        "Check that this DFP contains GCC support for ${AVR_MCU}.")
endif()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

find_program(CMAKE_C_COMPILER NAMES avr-gcc REQUIRED)
find_program(CMAKE_CXX_COMPILER NAMES avr-g++ REQUIRED)
find_program(CMAKE_ASM_COMPILER NAMES avr-gcc REQUIRED)
find_program(CMAKE_AR NAMES avr-gcc-ar avr-ar REQUIRED)
find_program(CMAKE_RANLIB NAMES avr-gcc-ranlib avr-ranlib REQUIRED)

find_program(AVR_OBJCOPY NAMES avr-objcopy REQUIRED)
find_program(AVR_OBJDUMP NAMES avr-objdump REQUIRED)
find_program(AVR_SIZE NAMES avr-size REQUIRED)

# -mmcu selects the core/device, predefined device macros, and the matching
# linker/device configuration. -B adds the DFP's GCC device-support directory
# to GCC's search path for device-specific support files.
set(_AVR_GNU_DEVICE_FLAGS "-mmcu=${AVR_MCU} -B${AVR_GCC_DEVICE_DIR}")
set(CMAKE_C_FLAGS_INIT "${_AVR_GNU_DEVICE_FLAGS}")
set(CMAKE_CXX_FLAGS_INIT "${_AVR_GNU_DEVICE_FLAGS}")
set(CMAKE_ASM_FLAGS_INIT "${_AVR_GNU_DEVICE_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${_AVR_GNU_DEVICE_FLAGS}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
