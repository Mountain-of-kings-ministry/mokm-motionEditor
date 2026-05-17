# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/apptemplate_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/apptemplate_autogen.dir/ParseCache.txt"
  "apptemplate_autogen"
  )
endif()
