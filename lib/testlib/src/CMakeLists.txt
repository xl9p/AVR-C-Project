add_library(testlib STATIC testlib.c)
target_include_directories(testlib PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include)
