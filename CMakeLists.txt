cmake_minimum_required(VERSION 3.18)
project(kspaceFirstOrder VERSION 3.6 LANGUAGES CXX)

# Set macOS SDK path if on macOS
if(APPLE)
    set(CMAKE_OSX_SYSROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX15.5.sdk")
endif()

# Set C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Options
option(USE_CUDA "Enable CUDA backend" OFF)
option(USE_OPENMP "Enable OpenMP backend" ON)
option(BUILD_TESTS "Build test suite" OFF)

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


