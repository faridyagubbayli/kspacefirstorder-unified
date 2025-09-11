include(FetchContent)

# Fetch HDF5
message(STATUS "Fetching HDF5...")
FetchContent_Declare(
    hdf5
    GIT_REPOSITORY https://github.com/HDFGroup/hdf5.git
    GIT_TAG        hdf5_1_14_4
    GIT_SHALLOW    TRUE
)

set(HDF5_BUILD_EXAMPLES OFF CACHE BOOL "")
set(HDF5_BUILD_TOOLS OFF CACHE BOOL "")
set(HDF5_BUILD_TESTS OFF CACHE BOOL "")
set(HDF5_BUILD_UTILS OFF CACHE BOOL "")
set(BUILD_SHARED_LIBS OFF CACHE BOOL "")
set(HDF5_ENABLE_PARALLEL OFF CACHE BOOL "")
set(HDF5_BUILD_HL_LIB ON CACHE BOOL "")

FetchContent_MakeAvailable(hdf5)

# Set HDF5 variables for compatibility
set(HDF5_FOUND TRUE)
set(HDF5_LIBRARIES hdf5-static hdf5_hl-static)
set(HDF5_INCLUDE_DIRS ${hdf5_SOURCE_DIR}/src ${hdf5_BINARY_DIR} ${hdf5_BINARY_DIR}/src)

# Fetch FFTW (for OpenMP backend)
if(USE_OPENMP)
    message(STATUS "Fetching FFTW3...")
    FetchContent_Declare(
        fftw3
        URL https://www.fftw.org/fftw-3.3.10.tar.gz
        URL_HASH SHA256=56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467
    )
    
    set(ENABLE_OPENMP ON CACHE BOOL "")
    set(ENABLE_THREADS ON CACHE BOOL "")
    set(BUILD_TESTS OFF CACHE BOOL "")
    set(DISABLE_FORTRAN ON CACHE BOOL "")
    
    FetchContent_MakeAvailable(fftw3)
    
    set(FFTW_FOUND TRUE)
    set(FFTW_LIBRARIES fftw3)
    set(FFTW_INCLUDE_DIRS ${fftw3_SOURCE_DIR}/api)
endif()

# Find CUDA (for CUDA backend)
if(USE_CUDA)
    find_package(CUDAToolkit QUIET)
    if(NOT CUDAToolkit_FOUND)
        message(WARNING "CUDA Toolkit not found - CUDA backend disabled")
        set(USE_CUDA OFF)
    else()
        enable_language(CUDA)
        # Set CUDA architectures
        set(CMAKE_CUDA_ARCHITECTURES 50 52 53 60 61 62 70 72 75 80 87 89 90 90a)
    endif()
endif()

# Find OpenMP
if(USE_OPENMP)
    find_package(OpenMP QUIET)
    if(NOT OpenMP_FOUND)
        message(WARNING "OpenMP not found - using compiler built-in support")
        # Don't disable OpenMP, many compilers have built-in support
    endif()
endif()
