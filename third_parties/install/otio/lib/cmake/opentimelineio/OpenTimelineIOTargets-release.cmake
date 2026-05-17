#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "OTIO::opentimelineio" for configuration "Release"
set_property(TARGET OTIO::opentimelineio APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(OTIO::opentimelineio PROPERTIES
  IMPORTED_LOCATION_RELEASE "/home/david/Documents/projects/software/MOKM MotionEditor/third_parties/install/otio/lib/libopentimelineio.so.0.19.0"
  IMPORTED_SONAME_RELEASE "libopentimelineio.so.19"
  )

list(APPEND _cmake_import_check_targets OTIO::opentimelineio )
list(APPEND _cmake_import_check_files_for_OTIO::opentimelineio "/home/david/Documents/projects/software/MOKM MotionEditor/third_parties/install/otio/lib/libopentimelineio.so.0.19.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
