# Given a Flatpak manifest path, configure a new manifest in CMAKE_BINARY_DIR. 
#
# Return path to the configured manifest in ${new_manifest_path}
#
# When configuring, process the tokens @plugin_name and @include.
#
# @plugin_name is replaced with the PLUGIN_API_NAME value from Plugin.cmake.
#
# @include are expected in lines like:
#
#     - @include libs/glu.yaml
#
# Copy the contents of the filename mentioned after @include into the new 
# manifest.
#  - Filename is relative to the project top-level directory.
#  - The indentation of the '-' char is added to each line in the included
#    file.

function(configure_manifest manifest new_manifest_path)

  # Compute generated manifest path and return in ${new_manifest_path}
  #
  if (${CMAKE_VERSION} VERSION_LESS 3.20)
    get_filename_component(manifest_basename ${manifest} NAME)
  else ()
    cmake_path(GET manifest FILENAME manifest_basename)
  endif ()
  set(new_manifest ${CMAKE_BINARY_DIR}/${manifest_basename})
  set(${new_manifest_path} ${new_manifest} PARENT_SCOPE)

  if (EXISTS ${new_manifest})
    return ()
  endif ()

  # Process @include
  #
  file(STRINGS ${manifest} lines)
  foreach (line ${lines})
    if ("${line}" MATCHES "@include")
      string(REGEX REPLACE "-.*" "" indent ${line})
      string(REGEX REPLACE ".*@include" "" path "${line}")
      string(STRIP "${path}" path)
      set(path ${CMAKE_SOURCE_DIR}/${path})
      file(STRINGS ${path} module_lines)
      foreach (line_ ${module_lines})
        file(APPEND ${new_manifest} "${indent}${line_}\n")
      endforeach()
    else ()
      file(APPEND ${new_manifest} "${line}\n")
    endif ()
  endforeach ()

  # Process @plugin_name and drop comments
  #
  file(STRINGS ${new_manifest} lines)
  file(WRITE ${new_manifest} "")
  foreach (line ${lines})
    if ("${line}" MATCHES "[ \t]*\#") 
      continue ()
    endif ()
    string(REPLACE @plugin_name ${PLUGIN_API_NAME} line "${line}")
    file(APPEND ${new_manifest} "${line}\n")
  endforeach ()
endfunction ()
