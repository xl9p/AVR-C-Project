set(AVR_MCU "avr128da28" CACHE STRING "AVR target device")
set(AVR_DFP_VERSION "2.8.343" CACHE STRING "Microchip AVR-Dx DFP version")
set(PACK_REPO_PATH "/opt" CACHE PATH
    "Root directory of the Microchip pack repository")

set(AVR_DFP_ROOT
    "${PACK_REPO_PATH}/Microchip/AVR-Dx_DFP/${AVR_DFP_VERSION}")
set(AVR_DFP_INCLUDE_DIR "${AVR_DFP_ROOT}/include")

set(AVR_GCC_DEVICE_DIR "${AVR_DFP_ROOT}/gcc/dev/${AVR_MCU}")
set(AVR_XC8_DEVICE_DIR "${AVR_DFP_ROOT}/xc8")

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
    AVR_MCU
    AVR_DFP_VERSION
    PACK_REPO_PATH
)

foreach(path IN ITEMS "${AVR_DFP_ROOT}" "${AVR_DFP_INCLUDE_DIR}")
    if(NOT IS_DIRECTORY "${path}")
        message(FATAL_ERROR
            "Required AVR-Dx DFP directory not found: ${path}\n"
            "Set PACK_REPO_PATH and AVR_DFP_VERSION to the installed pack.")
    endif()
endforeach()
