# OpenCPN wrapper for rtl-sdr
#
# Exports: ocpn::rtlsdr transitive link object
#
# See: https://osmocom.org/projects/rtl-sdr/wiki/Rtl-sdr.
#
# Library imported from https://github.com/pinkavaj/rtl-sdr at commit
#     4520f00 lib: fix FC0012 reset GPIO
#
# Patches:
#   - A new FindLibUSB.cmake, old one did not locate properly. This uses
#     a LIBUSB_1 rather that LIBUSB variable prefix, this is changed in
#     src/CMakeLists.txt
#   - src/CMakeLists.txt has been patched to only build the static library
#
# Copyright (C) 2022 Alec Leamas
#
# This program is free software; you can redistribute it and/or modify  *
# it under the terms of the GNU General Public License as published by  *
# the Free Software Foundation; either version 3 of the License, or     *
# (at your option) any later version.                                   *

cmake_minimum_required (VERSION 3.1.0)


if (TARGET ocpn::rtlsdr)
  return ()
endif ()
project(ocpn_rtlsdr)
cmake_policy(SET CMP0079 NEW)

add_library(rtlsdr_if INTERFACE)
add_library(ocpn::rtlsdr ALIAS rtlsdr_if)
target_link_libraries(rtlsdr_if INTERFACE ocpn::pthread)

set(srcdir ${CMAKE_CURRENT_LIST_DIR}/rtl-sdr)
if (WIN32)
  # Guide rtl-sdr/cmake/Modules/FindThreads
  get_property(THREAD_SRC TARGET ocpn::pthread PROPERTY SOURCE_DIR)
  set(THREADS_PTHREADS_WIN32_EXCEPTION_SCHEME "C")
  set(CMAKE_INCLUDE_PATH  ${THREAD_SRC}/win32/include)
endif ()

include_directories(${srcdir}/include)
add_subdirectory(rtl-sdr EXCLUDE_FROM_ALL)
target_link_libraries(rtlsdr_static ocpn::libusb)

target_link_libraries(rtlsdr_if INTERFACE rtlsdr_static)
target_include_directories(rtlsdr_if INTERFACE "${srcdir}/include")
