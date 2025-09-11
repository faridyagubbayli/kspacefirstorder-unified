# Unix platform library
if(PLATFORM_UNIX)
    # Collect Unix-specific header files
    set(UNIX_HEADERS
        ErrorMessagesLinux.h
        OutputMessagesLinux.h
    )

    # Create Unix library (header-only for now)
    add_library(kspace_unix INTERFACE)
    target_include_directories(kspace_unix INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
endif()


