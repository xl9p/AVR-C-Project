find_package(Doxygen REQUIRED)
add_custom_target(docs
    COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_SOURCE_DIR}/Doxyfile
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
)