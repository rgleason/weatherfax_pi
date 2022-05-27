# OpenCPN wrapper for libusb
#
# Exports: ocpn::libusb transitive link object
#
# Libusb is available in system libs on Linux and MacOS (both Homebrew
# and MacPorts). Windows uses bundled, pre-compiled binaries. Android
# is not supported.
#
# Windows requires installing separate libusb driver code.
#
# Copyright (C) 2022 Alec Leamas
#
# This program is free software; you can redistribute it and/or modify  *
# it under the terms of the GNU General Public License as published by  *
# the Free Software Foundation; either version 3 of the License, or     *
# (at your option) any later version.                                   *

cmake_minimum_required (VERSION 3.1.0)

if (TARGET ocpn::libusb)
  return ()
endif ()

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)

if (QT_ANDROID)
  message(STATUS "NOTE: libusb is not available on Android")
  return ()
endif ()

project(ocpn_libusb)

add_library(libusb_if INTERFACE)
add_library(ocpn::libusb ALIAS libusb_if)

if (WIN32)
  set(LibUSB_LIBRARY ${CMAKE_CURRENT_LIST_DIR}/win32/lib/libusb-1.0.lib)
  set(Getopt_LIBRARY ${CMAKE_CURRENT_LIST_DIR}/win32/lib/getopt.lib)
  set(LIBUSB_1_LIBRARIES ${LibUSB_LIBRARY} ${Getopt_LIBRARY}
    CACHE STRING "libusb libraries"
  )
  set(LIBUSB_1_INCLUDE_DIRS ${CMAKE_CURRENT_LIST_DIR}/win32/include/libusb-1.0
    CACHE STRING "libusb headers directory"
  )
else ()
  find_package(LibUSB REQUIRED)
endif ()

target_link_libraries(libusb_if INTERFACE ${LIBUSB_1_LIBRARIES})
target_include_directories(libusb_if INTERFACE  ${LIBUSB_1_INCLUDE_DIRS})
