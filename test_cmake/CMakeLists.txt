cmake_minimum_required(VERSION 3.18)
project(openmp_test)

# Set the same options as the main project
option(USE_OPENMP "Enable OpenMP backend" ON)

# Include our FindDependencies module
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")
include(FindDependencies)

# Create a simple test executable
add_executable(openmp_test ../test_openmp.cpp)

# Link against our OpenMP flags if available
if(USE_OPENMP AND TARGET kspace_openmp_flags)
    target_link_libraries(openmp_test kspace_openmp_flags)
endif()

# Show some debug info
message(STATUS "USE_OPENMP: ${USE_OPENMP}")
message(STATUS "CMAKE_CXX_COMPILER_ID: ${CMAKE_CXX_COMPILER_ID}")
if(TARGET kspace_openmp_flags)
    message(STATUS "kspace_openmp_flags target created successfully")
else()
    message(STATUS "kspace_openmp_flags target NOT created")
endif()
