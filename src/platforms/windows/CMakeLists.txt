# Windows platform library
if(PLATFORM_WINDOWS)
    # Collect Windows-specific header files
    set(WINDOWS_HEADERS
        ErrorMessagesWindows.h
        OutputMessagesWindows.h
    )

    # Create Windows library (header-only for now)
    add_library(kspace_windows INTERFACE)
    target_include_directories(kspace_windows INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
endif()


