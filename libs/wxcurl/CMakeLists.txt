cmake_minimum_required(VERSION 3.1)

if (TARGET ocpn::wxcurl)
    return ()
endif ()

if (NOT CMAKE_MODULE_PATH)
  set (CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
endif ()

# Library is used also in the plugins, so:
set(CMAKE_POSITION_INDEPENDENT_CODE "ON")

add_library(WXCURL_IF INTERFACE)
add_library(ocpn::wxcurl ALIAS WXCURL_IF)

set(_missing_curl_msg
[[wxcurl depends on the ocpn::libcurl library, please install this from
opencpn-libs and use it before using wxcurl. This build will run but is
deprecated, has no Android support and will break in a later release]]
)
if (NOT TARGET ocpn::libcurl)
  message(WARNING ${_missing_curl_msg})
endif ()


set(SRC
  include/curl
  include/curl/curlbuild.h
  include/curl/curlbuild.h.cmake
  include/curl/curlbuild.h.in
  include/curl/curl.h
  include/curl/curlrules.h
  include/curl/curlver.h
  include/curl/easy.h
  include/curl/mprintf.h
  include/curl/multi.h
  include/curl/stdcheaders.h
  include/curl/typecheck-gcc.h
  include/README
  src/base.cpp
  src/dav.cpp
  src/davtool.cpp
  src/dialog.cpp
  src/ftp.cpp
  src/ftpparse.cpp
  src/ftpparse.h
  src/ftptool.cpp
  src/http.cpp
  src/panel.cpp
  src/telnet.cpp
  src/thread.cpp
  src/utils.cpp
  src/wx/curl
  src/wx/curl/base.h
  src/wx/curl/dav.h
  src/wx/curl/davtool.h
  src/wx/curl/dialog.h
  src/wx/curl/ftp.h
  src/wx/curl/ftptool.h
  src/wx/curl/http.h
  src/wx/curl/panel.h
  src/wx/curl/telnet.h
  src/wx/curl/thread.h
  src/wx/curl/utils.h
)

add_library(WXCURL_SRC STATIC ${SRC})
target_include_directories(
  WXCURL_SRC PRIVATE ${CMAKE_CURRENT_LIST_DIR}/include ${CMAKE_CURRENT_LIST_DIR}/src
)
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  set_property(TARGET WXCURL_SRC PROPERTY COMPILE_FLAGS "-fvisibility=hidden")
endif ()

# The curl depenedency
#
if (WIN32 AND NOT TARGET ocpn::libcurl)
  set(_implib ${CMAKE_CURRENT_LIST_DIR}/win/libcurl.dll)
  add_library(CURL_LIBRARIES STATIC IMPORTED)
  set_property(
    TARGET CURL_LIBRARIES
    PROPERTY IMPORTED_LOCATION ${CMAKE_CURRENT_LIST_DIR}/win/libcurl.lib
  )
  target_link_libraries(WXCURL_SRC PUBLIC CURL_LIBRARIES)
  target_include_directories(
    WXCURL_SRC PUBLIC ${CMAKE_CURRENT_LIST_DIR}/include
  )
elseif (TARGET ocpn::libcurl)
  target_link_libraries(WXCURL_SRC PUBLIC ocpn::libcurl)
else ()
  find_package(CURL REQUIRED)
  target_link_libraries(WXCURL_SRC PUBLIC CURL::libcurl)
endif ()

# The public interface
target_include_directories(
  WXCURL_IF INTERFACE ${CMAKE_CURRENT_LIST_DIR}/include 
)
target_link_libraries(WXCURL_IF INTERFACE WXCURL_SRC ocpn::libcurl)
get_property(_libs TARGET WXCURL_IF PROPERTY INTERFACE_LINK_LIBRARIES)
