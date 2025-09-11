include(FetchContent)

# HDF5 Dependency Resolution
message(STATUS "Looking for HDF5...")
find_package(HDF5 QUIET COMPONENTS C HL)
if(HDF5_FOUND)
    message(STATUS "✓ Using system HDF5")
    set(HDF5_LIBRARIES ${HDF5_LIBRARIES} ${HDF5_HL_LIBRARIES})
else()
    # Try pkg-config approach for macOS/Homebrew
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        pkg_check_modules(HDF5_PC hdf5)
        pkg_check_modules(HDF5_HL_PC hdf5_hl)
        if(HDF5_PC_FOUND AND HDF5_HL_PC_FOUND)
            set(HDF5_FOUND TRUE)
            set(HDF5_LIBRARIES ${HDF5_HL_PC_LDFLAGS} ${HDF5_PC_LDFLAGS})
            set(HDF5_INCLUDE_DIRS ${HDF5_PC_INCLUDE_DIRS} ${HDF5_HL_PC_INCLUDE_DIRS})
            message(STATUS "✓ Using system HDF5 (via pkg-config)")
        endif()
    endif()

    if(NOT HDF5_FOUND)
        message(STATUS "⚠ System HDF5 not found, fetching from source...")
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
        message(STATUS "✓ Built HDF5 from source")
    endif()
endif()

# FFTW3 Dependency Resolution (for OpenMP backend)
if(USE_OPENMP)
    set(FFTW_SYSTEM_FOUND FALSE)
    find_package(PkgConfig QUIET)
    if(PKG_CONFIG_FOUND)
        pkg_check_modules(FFTW3F fftw3f>=3.3)
    if(FFTW3F_FOUND)
        set(FFTW_SYSTEM_FOUND TRUE)
        set(FFTW_FOUND TRUE)
        # Use the full linker flags from pkg-config to ensure proper linking
        set(FFTW_LIBRARIES ${FFTW3F_LDFLAGS})
        set(FFTW_INCLUDE_DIRS ${FFTW3F_INCLUDE_DIRS})
        message(STATUS "✓ Using system FFTW3 (single-precision)")
    endif()
    endif()

    if(NOT FFTW_SYSTEM_FOUND)
        message(STATUS "⚠ System FFTW3 not found, fetching from source...")
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
        message(STATUS "✓ Built FFTW3 from source")
    endif()
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
