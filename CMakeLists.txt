cmake_minimum_required(VERSION 3.18)

if(USE_CUDA)
    project(kspaceFirstOrder VERSION 3.6 LANGUAGES C CXX CUDA)
else()
    project(kspaceFirstOrder VERSION 3.6 LANGUAGES C CXX)
endif()

# Set macOS SDK path if on macOS
if(APPLE)
    # The following line is removed as it's not portable.
    # set(CMAKE_OSX_SYSROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX15.5.sdk")
endif()

# Options
option(USE_CUDA "Enable CUDA backend" OFF)
option(USE_OPENMP "Enable OpenMP backend" ON)
option(BUILD_TESTS "Build test suite" OFF)
option(ENABLE_NATIVE_ARCH "Enable march=native for performance" ON)

# Auto-detect and use sccache for build acceleration if available
find_program(SCCACHE_PROGRAM sccache)
if(SCCACHE_PROGRAM)
    message(STATUS "✓ Found sccache, enabling compiler cache.")
    set(CMAKE_C_COMPILER_LAUNCHER ${SCCACHE_PROGRAM})
    set(CMAKE_CXX_COMPILER_LAUNCHER ${SCCACHE_PROGRAM})
    if(USE_CUDA)
        set(CMAKE_CUDA_COMPILER_LAUNCHER ${SCCACHE_PROGRAM})
    endif()
endif()

# Include CMake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Find dependencies
include(FindDependencies)

# Platform detection
include(PlatformDetection)

# Compiler flags
include(CompilerFlags)

# Add subdirectories
add_subdirectory(src)

if(BUILD_TESTS)
    add_subdirectory(tests)
endif()


