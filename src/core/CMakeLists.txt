# Core library (always built)
set(CORE_SOURCES
    Containers/MatrixContainer.cpp
    Containers/OutputStreamContainer.cpp
    HDF5/Hdf5File.cpp
    HDF5/Hdf5FileHeader.cpp
    KSpaceFirstOrderSolver.cpp
    Logger.cpp
    MatrixClasses/BaseFloatMatrix.cpp
    MatrixClasses/BaseIndexMatrix.cpp
    MatrixClasses/ComplexMatrix.cpp
    MatrixClasses/IndexMatrix.cpp
    MatrixClasses/RealMatrix.cpp
    OutputStreams/BaseOutputStream.cpp
    OutputStreams/CuboidOutputStream.cpp
    OutputStreams/IndexOutputStream.cpp
    OutputStreams/WholeDomainOutputStream.cpp
    CommandLineParameters.cpp
    Parameters.cpp
)

set(CORE_HEADERS
    Containers/MatrixContainer.h
    Containers/MatrixRecord.h
    Containers/OutputStreamContainer.h
    HDF5/Hdf5File.h
    HDF5/Hdf5FileHeader.h
    KSpaceFirstOrderSolver.h
    ErrorMessages.h
    Logger.h
    OutputMessages.h
    MatrixClasses/BaseFloatMatrix.h
    MatrixClasses/BaseIndexMatrix.h
    MatrixClasses/BaseMatrix.h
    MatrixClasses/ComplexMatrix.h
    MatrixClasses/IndexMatrix.h
    MatrixClasses/RealMatrix.h
    OutputStreams/BaseOutputStream.h
    OutputStreams/CuboidOutputStream.h
    OutputStreams/IndexOutputStream.h
    OutputStreams/WholeDomainOutputStream.h
    CommandLineParameters.h
    Parameters.h
    Utils/DimensionSizes.h
    Utils/TimeMeasure.h
)

# Create core library
add_library(kspace_core ${CORE_SOURCES} ${CORE_HEADERS})
target_include_directories(kspace_core PUBLIC 
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/src/platforms
    ${HDF5_INCLUDE_DIRS}
)

# Link HDF5 to core library
target_link_libraries(kspace_core PUBLIC ${HDF5_LIBRARIES})

# Add FFTW includes if using OpenMP
if(USE_OPENMP AND FFTW_FOUND)
    target_include_directories(kspace_core PUBLIC ${FFTW_INCLUDE_DIRS})
endif()
