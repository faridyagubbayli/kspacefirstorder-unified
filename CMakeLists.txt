cmake_minimum_required(VERSION 3.18)

if(USE_CUDA)
    project(kspaceFirstOrder VERSION 3.6 LANGUAGES CXX CUDA)
else()
    project(kspaceFirstOrder VERSION 3.6 LANGUAGES CXX)
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


