# OpenCPN wrapper for libcurl -- https://curl.se/libcurl/
#
# Exports: ocpn::libcurl transitive link object
#
# Depends: libcurl-dev on Debian (build); runtime pulled in by OpenCPN
#
# Pre-compiled Android libraries obtained from 
# https://github.com/robertying/openssl-curl-android, version 1.1.1l-7.78.0 
#
# Copyright (C) 2022 Alec Leamas
#
# This program is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

cmake_minimum_required (VERSION 3.1.0)

set(curl_version 7.83.1)   # Actual version for built library

if (TARGET ocpn::libcurl)
  return ()
endif ()

project(ocpn_curl)

add_library(curl_if INTERFACE)
add_library(ocpn::libcurl ALIAS curl_if)

macro(set_location what where)
  set_property(
    TARGET ${what}
    PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_LIST_DIR}/${where}
  )
endmacro ()

if (QT_ANDROID)
  # Android: use the precompiled libraries and be done with it.
  #
  add_library(_CURL_ANDROID STATIC IMPORTED)
  add_library(_CURL_SSL STATIC IMPORTED)
  add_library(_CURL_CRYPTO STATIC IMPORTED)
  if (CMAKE_SIZEOF_VOID_P MATCHES "8") 
    set_location(_CURL_ANDROID armeabi-v7a/lib/libcurl.a)
    set_location(_CURL_SSL openssl/armeabi-v7a/lib/libcrypto.a)
    set_location(_CURL_CRYPTO openssl/armeabi-v7a/lib/libcrypto.a)
    target_include_directories(
      curl_if INTERFACE ${CMAKE_CURRENT_LIST_DIR}/arm64-v8a/include
    )
  else ()
    set_location(_CURL_ANDROID arm64-v8a/lib/libcurl.a)
    set_location(_CURL_SSL openssl/arm64-v8a/lib/libssl.a)
    set_location(_CURL_CRYPTO openssl/arm64-v8a/lib/libcrypto.a)
    target_include_directories(
      curl_if INTERFACE ${CMAKE_CURRENT_LIST_DIR}/armeabi-v7a/include
    )
  endif ()
  target_link_libraries(
    curl_if INTERFACE  _CURL_ANDROID _CURL_SSL _CURL_CRYPTO
  )
  return()
endif ()

if (WIN32)
  # Windows: Use precompiled libraries and be done.
  #
  target_link_libraries(
    curl_if INTERFACE "${CMAKE_CURRENT_LIST_DIR}/win32/lib/libcurl.lib"
  )
  target_include_directories(
    curl_if INTERFACE "${CMAKE_CURRENT_LIST_DIR}/win32/include"
  )
  return()
endif ()

if (UNIX AND NOT APPLE)
  #  Linux and Flatpak: use the system library and be done with it.
  #
  find_library(LIBCURL NAMES libcurl curl REQUIRED)
  if (${CMAKE_VERSION} VERSION_LESS 3.18)
    find_path(CURL_HEADERS NAMES curl.h PATH_SUFFIXES curl)
  else ()
    find_path(CURL_HEADERS NAMES curl.h PATH_SUFFIXES curl REQUIRED)
  endif ()
  target_link_libraries(curl_if INTERFACE ${LIBCURL})
  target_include_directories(curl_if INTERFACE ${CURL_HEADERS})
  return ()
endif ()

set(curl_tarball "curl-${curl_version}.tar.gz")
set(curl_url https://curl.se/download/${curl_tarball})
set(curl_cache_dir "${CMAKE_CURRENT_LIST_DIR}/cache")
set(curl_srcdir "${curl_cache_dir}/curl-${curl_version}")

# Make sure the tarball is downloaded and unpacked
if (NOT EXISTS ${curl_srcdir})
  # Some Debian/Ubuntu versions have buggy curl and hence file(DOWNLOAD ...):
  execute_process(COMMAND cmake -E make_directory ${curl_cache_dir})
  if (NOT EXISTS "${curl_cache_dir}/${curl_tarball}")
    execute_process(
      COMMAND wget -nv -O "${curl_cache_dir}/${curl_tarball}" ${curl_url}
    )
  endif ()
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar -xzf "${curl_cache_dir}/${curl_tarball}"
    WORKING_DIRECTORY "${curl_cache_dir}"
  )
endif ()

if (EXISTS  /usr/local/Cellar/openssl@3/)
  file(GLOB  _ssl_root_path /usr/local/Cellar/openssl@3/*/)
  set(OPENSSL_ROOT_DIR ${_ssl_root_path} CACHE STRING "" FORCE)
  message(STATUS "Looking for ssl libraries in ${_ssl_root_path}")
endif ()


if ("${CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build release executable" FORCE)
endif ()
set(BUILD_SHARED_LIBS OFF CACHE BOOL "Disable shared libs" FORCE)
set(BUILD_TESTING OFF CACHE STRING "Dont build tests" FORCE)
set(BUILD_CURL_EXE OFF CACHE BOOL "Build the curl(1) executable" FORCE)

set(CURL_DISABLE_GOPHER ON CACHE BOOL "Disable Gopher support" FORCE)
set(CURL_DISABLE_HSTS ON CACHE BOOL "Disable Hsts support" FORCE)
set(CURL_DISABLE_IMAP ON CACHE BOOL "Disable IMAP support" FORCE)
set(CURL_DISABLE_LDAP ON CACHE BOOL "Disable LDAP support" FORCE)
set(CURL_DISABLE_LDAPS ON CACHE BOOL "Disable LDAPS support" FORCE)
set(CURL_DISABLE_MIME ON CACHE BOOL "Disable MIME support" FORCE)
set(CURL_DISABLE_MQTT ON CACHE BOOL "Disable MQTT support" FORCE)
set(CURL_DISABLE_NTLM ON CACHE BOOL "Disable NTLM support" FORCE)
set(CURL_DISABLE_POP3 ON CACHE BOOL "Disable POP3 support" FORCE)
set(CURL_DISABLE_SMB ON CACHE BOOL "Disable SMB support" FORCE)
set(CURL_DISABLE_TELNET ON CACHE BOOL "Disable telnet support" FORCE)
set(ENABLE_MANUAL OFF CACHE BOOL "Don't build manual" FORCE)

if (WIN32)
  set(ENABLE_INET_PTON OFF CACHE BOOL "Disable for XP compatibility")
endif ()

add_subdirectory(${curl_srcdir})

target_link_libraries(curl_if INTERFACE libcurl)
target_include_directories(curl_if INTERFACE "${curl_srcdir}/include")
