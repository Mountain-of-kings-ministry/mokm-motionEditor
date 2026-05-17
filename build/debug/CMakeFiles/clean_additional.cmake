# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/mokmEditor_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/mokmEditor_autogen.dir/ParseCache.txt"
  "mokmEditor_autogen"
  )
endif()
