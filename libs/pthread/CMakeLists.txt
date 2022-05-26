# OpenCPN wrapper for pthread
#
# Exports: ocpn::pthread transitive link object
#
# pthread is available by default on all platforms besides 
# win32. Here, precompiled binaries from
# https://sourceforge.net/projects/pthreads4w/ is used.
# The bundled library is built without exception support.
#
# Version used is pthreads-w32-2-9-1-release.zip, it might make
# sense to rebuild from available, updated sources.
#
# Copyright (C) 2022 Alec Leamas
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

cmake_minimum_required (VERSION 3.1.0)

if (TARGET ocpn::pthread)
  return ()
endif ()

project(ocpn_pthread)

add_library(pthread_if INTERFACE)
add_library(ocpn::pthread ALIAS pthread_if)

if (WIN32)
  set(PTHREAD_LIBRARIES ${CMAKE_CURRENT_LIST_DIR}/win32/lib/pthreadVC2.lib
    CACHE STRING "Windows pthread library location"
  )
  set(PTHREAD_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}/win32/include
    CACHE STRING "Windows pthread headers directory"
  )
  target_link_libraries(pthread_if INTERFACE ${PTHREAD_LIBRARIES})
  target_include_directories(pthread_if INTERFACE  ${PTHREAD_INCLUDE_DIRS})
else ()
  target_compile_options(pthread_if INTERFACE -lpthread )
endif ()
