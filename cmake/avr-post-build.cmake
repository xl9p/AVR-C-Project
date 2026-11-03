foreach(var IN ITEMS AVR_OBJCOPY AVR_OBJDUMP AVR_SIZE AVR_ELF AVR_OUTPUT_DIR AVR_IMAGE_NAME)
    if(NOT DEFINED ${var} OR "${${var}}" STREQUAL "")
        message(FATAL_ERROR "avr-post-build.cmake: missing ${var}")
    endif()
endforeach()

file(MAKE_DIRECTORY "${AVR_OUTPUT_DIR}")
set(base "${AVR_OUTPUT_DIR}/${AVR_IMAGE_NAME}")

function(run_tool description)
    execute_process(
        COMMAND ${ARGN}
        RESULT_VARIABLE result
        ERROR_VARIABLE stderr
    )
    if(NOT result EQUAL 0)
        message(FATAL_ERROR "${description} failed (${result}):\n${stderr}")
    endif()
endfunction()

run_tool("Intel HEX conversion"
    "${AVR_OBJCOPY}" --output-target=ihex "${AVR_ELF}" "${base}.hex")
run_tool("EEPROM image conversion"
    "${AVR_OBJCOPY}" --only-section=.eeprom --change-section-lma .eeprom=0
    --no-change-warnings --output-target=ihex "${AVR_ELF}" "${base}.eep")
run_tool("S-record conversion"
    "${AVR_OBJCOPY}" --output-target=srec
    --remove-section=.eeprom --remove-section=.fuse
    --remove-section=.lock --remove-section=.signature
    "${AVR_ELF}" "${base}.srec")
run_tool("User-signature image conversion"
    "${AVR_OBJCOPY}" --only-section=.user_signatures
    --change-section-lma .user_signatures=0 --no-change-warnings
    --output-target=ihex "${AVR_ELF}" "${base}.usersignatures")

execute_process(
    COMMAND "${AVR_OBJDUMP}" --disassemble --wide --demangle
        --line-numbers --section-headers --source "${AVR_ELF}"
    OUTPUT_FILE "${base}.lss"
    RESULT_VARIABLE result
    ERROR_VARIABLE stderr
)
if(NOT result EQUAL 0)
    message(FATAL_ERROR "Disassembly listing generation failed (${result}):\n${stderr}")
endif()

execute_process(
    COMMAND "${AVR_OBJDUMP}" -Pmem-usage "${AVR_ELF}"
    OUTPUT_FILE "${base}.mem"
    RESULT_VARIABLE mem_usage_result
    ERROR_VARIABLE mem_usage_stderr
)
