# OpenMP backend library
if(USE_OPENMP)
    # Collect OpenMP source files
    set(OPENMP_SOURCES
        MatrixClasses/FftwComplexMatrix.cpp
        MatrixClasses/FftwRealMatrix.cpp
    )

    # Collect OpenMP header files
    set(OPENMP_HEADERS
        MatrixClasses/FftwComplexMatrix.h
        MatrixClasses/FftwRealMatrix.h
    )

    # Create OpenMP library
    add_library(kspace_openmp ${OPENMP_SOURCES} ${OPENMP_HEADERS})
    target_include_directories(kspace_openmp PUBLIC 
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_SOURCE_DIR}/src
        ${CMAKE_SOURCE_DIR}/src/core
        ${HDF5_INCLUDE_DIRS}
        ${FFTW_INCLUDE_DIRS}
    )
    
    # Link FFTW libraries
    target_link_libraries(kspace_openmp PUBLIC ${FFTW_LIBRARIES})
    
    # Link OpenMP if found
    if(OpenMP_CXX_FOUND)
        target_link_libraries(kspace_openmp PUBLIC OpenMP::OpenMP_CXX)
    else()
        # For Apple Clang, we might need to use libomp from Homebrew or build without OpenMP
        message(STATUS "OpenMP not found - building without OpenMP threading support")
    endif()
endif()


