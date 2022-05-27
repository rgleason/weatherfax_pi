# OpenCPN wrapper for audiofile
#
# Exports: ocpn::audiofile transitive link object.
#
# See: https://audiofile.68k.org/
#
# Imported from bundled sources in weatherfax_pi
#
# Copyright (C) 2022 Alec Leamas
#
# This program is free software; you can redistribute it and/or modify  *
# it under the terms of the GNU General Public License as published by  *
# the Free Software Foundation; either version 3 of the License, or     *
# (at your option) any later version.                                   *

cmake_minimum_required(VERSION 3.1.0)

project(libaudiofile)

if (TARGET ocpn::audiofile)
  return()
endif ()
set(
  SRC
  
  src/aes.cpp
  src/af_vfs.cpp
  src/AIFF.cpp
  src/alac
  src/audiofile.exports
  src/AudioFormat.cpp
  src/aupv.c
  src/AVR.cpp
  src/Buffer.cpp
  src/CAF.cpp
  src/compression.cpp
  src/data.cpp
  src/debug.cpp
  src/error.c
  src/extended.c
  src/File.cpp
  src/FileHandle.cpp
  src/FLACFile.cpp
  src/format.cpp
  src/g711.c
  src/IFF.cpp
  src/Instrument.cpp
  src/IRCAM.cpp
  src/Loop.cpp
  src/Makefile.am
  src/Marker.cpp
  src/Miscellaneous.cpp
  src/modules
  src/NeXT.cpp
  src/NIST.cpp
  src/openclose.cpp
  src/PacketTable.cpp
  src/pcm.cpp
  src/query.cpp
  src/Raw.cpp
  src/SampleVision.cpp
  src/Setup.cpp
  src/Track.cpp
  src/units.cpp
  src/util.cpp
  src/UUID.cpp
  src/VOC.cpp
  src/WAVE.cpp

  src/modules/ALAC.cpp
  src/modules/BlockCodec.cpp
  src/modules/FileModule.cpp
  src/modules/FLAC.cpp
  src/modules/G711.cpp
  src/modules/IMA.cpp
  src/modules/Makefile.am
  src/modules/Module.cpp
  src/modules/ModuleState.cpp
  src/modules/MSADPCM.cpp
  src/modules/PCM.cpp
  src/modules/RebufferModule.cpp
  src/modules/SimpleModule.cpp
  src/modules/UT_RebufferModule.cpp

  src/alac/ag_dec.c
  src/alac/ag_enc.c
  src/alac/ALACBitUtilities.c
  src/alac/ALACDecoder.cpp
  src/alac/ALACEncoder.cpp
  src/alac/dp_dec.c
  src/alac/dp_enc.c
  src/alac/EndianPortable.c
  src/alac/Makefile.am
  src/alac/matrix_dec.c
  src/alac/matrix_enc.c
  
  src/afinternal.h
  src/af_vfs.h
  src/AIFF.h
  src/alac
  src/audiofile.h
  src/AudioFormat.h
  src/aupvinternal.h
  src/aupvlist.h
  src/AVR.h
  src/Buffer.h
  src/byteorder.h
  src/CAF.h
  src/Compiler.h
  src/compression.h
  src/config.h
  src/debug.h
  src/error.h
  src/extended.h
  src/Features.h
  src/File.h
  src/FileHandle.h
  src/FLACFile.h
  src/g711.h
  src/IFF.h
  src/Instrument.h
  src/IRCAM.h
  src/Marker.h
  src/modules
  src/NeXT.h
  src/NIST.h
  src/PacketTable.h
  src/pcm.h
  src/Raw.h
  src/SampleVision.h
  src/Setup.h
  src/Shared.h
  src/Tag.h
  src/Track.h
  src/units.h
  src/util.h
  src/UUID.h
  src/VOC.h
  src/WAVE.h
  src
  src/modules/ALAC.h
  src/modules/BlockCodec.h
  src/modules/FileModule.h
  src/modules/FLAC.h
  src/modules/G711.h
  src/modules/IMA.h
  src/modules/Module.h
  src/modules/ModuleState.h
  src/modules/MSADPCM.h
  src/modules/PCM.h
  src/modules/RebufferModule.h
  src/modules/SimpleModule.h
  src
  src/alac/aglib.h
  src/alac/ALACAudioTypes.h
  src/alac/ALACBitUtilities.h
  src/alac/ALACDecoder.h
  src/alac/ALACEncoder.h
  src/alac/dplib.h
  src/alac/EndianPortable.h
  src/alac/matrixlib.h
)

add_library(_AUDIOFILE_IF INTERFACE)
add_library(ocpn::audiofile ALIAS _AUDIOFILE_IF)

# This is old code generating somm warnings that cannot reasobabley be dealt with.
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  string(APPEND CMAKE_CXX_FLAGS " -Wno-multichar")
  string(APPEND CMAKE_CXX_FLAGS " -Wno-deprecated-declarations")
  string(APPEND CMAKE_C_FLAGS " -Wno-multichar")
endif ()

add_library(AUDIOFILE STATIC ${SRC})
target_include_directories(AUDIOFILE PUBLIC ${CMAKE_CURRENT_LIST_DIR}/src)
if (DEFINED ENV{FLATPAK_DEST})
  target_include_directories(AUDIOFILE PRIVATE $ENV{FLATPAK_DEST}/include)
endif ()
target_link_libraries(_AUDIOFILE_IF INTERFACE AUDIOFILE)
target_include_directories(AUDIOFILE PUBLIC ${CMAKE_CURRENT_LIST_DIR}/src)
target_link_libraries(AUDIOFILE PRIVATE ocpn::gtest)
