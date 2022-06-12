# ~~~
# Summary:      Local, non-generic plugin setup
# Copyright (c) 2020-2021 Mike Rossiter
# License:      GPLv3+
# ~~~

#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.


# -------- Options ----------

set(OCPN_TEST_REPO
    "opencpn/weatherfax-alpha"
    CACHE STRING "Default repository for untagged builds"
)
set(OCPN_BETA_REPO
    "opencpn/weatherfax-beta"
    CACHE STRING
    "Default repository for tagged builds matching 'beta'"
)
set(OCPN_RELEASE_REPO
    "opencpn/weatherfax-prod"
    CACHE STRING
    "Default repository for tagged builds not matching 'beta'"
)

if (QT_ANDROID)
  set(WEATHERFAX_USE_RTLSDR OFF)
elseif (UNIX)
  set(WEATHERFAX_USE_RTLSDR ON)
elseif (WIN32)
  option(
    WEATHERFAX_USE_RTLSDR
    "Build and use rtlsdr, requires libusb driver installed"
    OFF
  )
else ()
  message(WARNING "Unknonw platform")
endif ()

#
# -------  Plugin setup --------
#
set(PKG_NAME weatherfax_pi)
set(PKG_VERSION  1.9.30.10)
set(PKG_PRERELEASE "")  # Empty, or a tag like 'beta'

set(DISPLAY_NAME Weatherfax)    # Dialogs, installer artifacts, ...
set(PLUGIN_API_NAME WeatherFax) # As of GetCommonName() in plugin API
set(PKG_SUMMARY "Open fax image, decode audio fax, chart overlay")
set(PKG_DESCRIPTION [=[
Open image files, decode audio fax to an image, calibrate chart
overlay image. Convert images in mercator, polar, conic and uniform
coordinates. Convert any image into a raster chart. Built in HF Radio
Fax database for SSB and Internet retrieval from meterological sites.
]=])

set(PKG_AUTHOR "Sean d'Epagnier")
set(PKG_IS_OPEN_SOURCE "yes")
set(PKG_HOMEPAGE https://github.com/rgleason/weatherfax_pi)
set(PKG_INFO_URL https://opencpn.org/OpenCPN/plugins/weatherfax.html)

set(SRC
  src/AboutDialog.cpp
  src/AboutDialog.h
  src/DecoderOptionsDialog.cpp
  src/DecoderOptionsDialog.h
  src/defs.h
  src/FaxDecoder.cpp
  src/FaxDecoder.h
  src/georef.h
  src/icons.cpp
  src/icons.h
  src/InternetRetrievalDialog.cpp
  src/InternetRetrievalDialog.h
  src/SchedulesDialog.cpp
  src/SchedulesDialog.h
  src/WeatherFax.cpp
  src/WeatherFax.h
  src/WeatherFaxImage.cpp
  src/WeatherFaxImage.h
  src/WeatherFaxUI.cpp
  src/WeatherFaxUI.h
  src/WeatherFaxWizard.cpp
  src/WeatherFaxWizard.h
  src/weatherfax_pi.cpp
  src/weatherfax_pi.h
  src/wximgkap.cpp
  src/wximgkap.h

  ocpn-misc/cutil.cpp
  ocpn-misc/cutil.h
  ocpn-misc/vector2D.h

  odapi/ODAPI.h
  odapi/ODJSONSchemas.h
)

set(PKG_API_LIB api-16)  # A directory in opencpn-libs e. g., api-17 or api-16

macro(late_init)
  # Perform initialization after the PACKAGE_NAME library, compilers
  # and ocpn::api is available.

  cmake_policy(SET CMP0066 NEW)
endmacro ()

macro(add_plugin_libraries)
  # Add libraries required by this plugin

  if (WEATHERFAX_USE_RTLSDR)
    add_subdirectory("${CMAKE_SOURCE_DIR}/libs/libusb")
    target_link_libraries(${PACKAGE_NAME} ocpn::libusb)

    add_subdirectory("${CMAKE_SOURCE_DIR}/libs/pthread")
    target_link_libraries(${PACKAGE_NAME} ocpn::pthread)

    add_subdirectory("${CMAKE_SOURCE_DIR}/libs/rtl-sdr")
    target_link_libraries(${PACKAGE_NAME} ocpn::rtlsdr)
  endif ()

  add_subdirectory("${CMAKE_SOURCE_DIR}/opencpn-libs/tinyxml")
  target_link_libraries(${PACKAGE_NAME} ocpn::tinyxml)

  # The wxsvg library enables SVG overall in the plugin
  add_subdirectory("${CMAKE_SOURCE_DIR}/opencpn-libs/wxsvg")
  target_link_libraries(${PACKAGE_NAME} ocpn::wxsvg)

  add_subdirectory("${CMAKE_SOURCE_DIR}/opencpn-libs/wxJSON")
  target_link_libraries(${PACKAGE_NAME} ocpn::wxjson)

  add_subdirectory("${CMAKE_SOURCE_DIR}/opencpn-libs/opencpn-glu")
  target_link_libraries(${PACKAGE_NAME} opencpn::glu)

  add_subdirectory("${CMAKE_SOURCE_DIR}/opencpn-libs/plugingl")
  target_link_libraries(${PACKAGE_NAME} ocpn::plugingl)

  add_subdirectory("${CMAKE_SOURCE_DIR}/opencpn-libs/curl")
  target_link_libraries(${PACKAGE_NAME} ocpn::libcurl)

  add_subdirectory("${CMAKE_SOURCE_DIR}/libs/wxcurl")
  target_link_libraries(${PACKAGE_NAME} ocpn::wxcurl)

  add_subdirectory("${CMAKE_SOURCE_DIR}/libs/googletest")
  target_link_libraries(${PACKAGE_NAME} ocpn::gtest)

  add_subdirectory("${CMAKE_SOURCE_DIR}/libs/audiofile")
  target_link_libraries(${PACKAGE_NAME} ocpn::audiofile)

endmacro ()
