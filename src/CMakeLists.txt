# Core library (always built)
add_subdirectory(core)

# Backend-specific libraries (depend on core)
if(USE_CUDA)
    add_subdirectory(backends/cuda)
endif()

if(USE_OPENMP)
    add_subdirectory(backends/openmp)
endif()

# Platform-specific libraries
if(PLATFORM_UNIX)
    add_subdirectory(platforms/unix)
elseif(PLATFORM_WINDOWS)
    add_subdirectory(platforms/windows)
endif()

# Main executable
add_executable(kspaceFirstOrder main.cpp)
target_link_libraries(kspaceFirstOrder PRIVATE
    kspace_core
    kspace_openmp
    ${HDF5_LIBRARIES}
    ${FFTW_LIBRARIES}
    kspace_openmp_flags
)

# Include directories for fetched dependencies
target_include_directories(kspaceFirstOrder PRIVATE ${HDF5_INCLUDE_DIRS})
if(USE_OPENMP AND FFTW_FOUND)
    target_include_directories(kspaceFirstOrder PRIVATE ${FFTW_INCLUDE_DIRS})
endif()


