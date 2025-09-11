# Detect operating system
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set(PLATFORM_LINUX ON)
    set(PLATFORM_UNIX ON)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(PLATFORM_MACOS ON)
    set(PLATFORM_UNIX ON)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    set(PLATFORM_WINDOWS ON)
else()
    message(FATAL_ERROR "Unsupported platform: ${CMAKE_SYSTEM_NAME}")
endif()

# Set platform-specific defines
if(PLATFORM_LINUX)
    add_definitions(-D__PLATFORM_LINUX__)
elseif(PLATFORM_MACOS)
    add_definitions(-D__PLATFORM_MACOS__)
elseif(PLATFORM_WINDOWS)
    add_definitions(-D__PLATFORM_WINDOWS__)
endif()


