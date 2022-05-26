# OpenCPN wrapper for googletest -- https://github.com/google/googletest
#
# Exports: ocpn::gtest transitive link object
#
# Copyright (C) 2022 Alec Leamas
#
# This program is free software; you can redistribute it and/or modify  *
# it under the terms of the GNU General Public License as published by  *
# the Free Software Foundation; either version 3 of the License, or     *
# (at your option) any later version.                                   *

cmake_minimum_required (VERSION 3.1.0)

if (TARGET gtest::gtest)
  return ()
endif ()

project(ocpn_gtest)

cmake_policy(SET CMP0079 NEW)

add_library(gtest_if INTERFACE)
add_library(ocpn::gtest ALIAS gtest_if)

set(_gtest_git_tag release-1.11.0)
set(_gtest_git_url https://github.com/google/googletest)
set(_gtest_srcdir ${CMAKE_BINARY_DIR}/googletest)

if (NOT EXISTS ${_gtest_srcdir})
  execute_process(
    COMMAND git clone -b ${_gtest_git_tag} ${_gtest_git_url} ${_gtest_srcdir}
  )
endif ()

set(BUILD_SHARED_LIBS OFF)
set(BUILD_GMOCK OFF)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
add_subdirectory(
  ${_gtest_srcdir} ${CMAKE_BINARY_DIR}/googletest.binary EXCLUDE_FROM_ALL
)

target_link_libraries(gtest_if INTERFACE gtest_main)
target_include_directories(gtest_if INTERFACE ${_gtest_srcdir}/include)
