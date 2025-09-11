# Common flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

# Release optimization
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG")

# Debug flags
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")

# Backend-specific defines
if(USE_CUDA)
    add_definitions(-DUSE_CUDA)
    set(CMAKE_CUDA_FLAGS "${CMAKE_CUDA_FLAGS} -O3 --restrict")
endif()

if(USE_OPENMP)
    add_definitions(-DUSE_OPENMP)
    # Don't add OpenMP flags here - let the OpenMP backend handle it
    # Apple Clang doesn't support -fopenmp flag directly
endif()

# Platform-specific flags
if(PLATFORM_LINUX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
elseif(PLATFORM_MACOS)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=native")
elseif(PLATFORM_WINDOWS)
    # Windows-specific flags
endif()


