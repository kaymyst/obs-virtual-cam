cmake_minimum_required(VERSION 3.5)
project(obs-virtualsource)

find_package(FFmpeg COMPONENTS swscale REQUIRED)

set(virtualsource_SOURCES
	dllmain.cpp
	virtualsource.rc
	virtual-cam.cpp
	virtual-audio.cpp
	clock.cpp
	virtual-source.def
	../queue/share_queue_read.cpp
	)

set(virtualsource_HEADERS
	virtual-cam.h
	virtual-audio.h
	clock.h
	../queue/share_queue_read.h
	../queue/share_queue.h
	)

if(WIN32)
	set(OBS_VIRTUALSOURCE_VERSION_MAJOR 2)
	set(OBS_VIRTUALSOURCE_VERSION_MINOR 1)
	set(OBS_VIRTUALSOURCE_VERSION_PATCH 1)
	set(OBS_VIRTUALSOURCE_VERSION_STRING "2.1.1")
	configure_file(${CMAKE_CURRENT_SOURCE_DIR}/virtualsource.rc.in ${CMAKE_CURRENT_SOURCE_DIR}/virtualsource.rc)
endif()

set(DShowPath "../../dshowdeps/include")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	find_library(DShowLib strmbase PATHS "../../dshowdeps/lib/x64" NO_DEFAULT_PATH)
	find_library(DShowLibD strmbasd PATHS "../../dshowdeps/lib/x64" NO_DEFAULT_PATH)
else()
	find_library(DShowLib strmbase PATHS "../../dshowdeps/lib/x86" NO_DEFAULT_PATH)
	find_library(DShowLibD strmbasd PATHS "../../dshowdeps/lib/x86" NO_DEFAULT_PATH)
endif()

add_library(obs-virtualsource MODULE
	${virtualsource_SOURCES}
	${virtualsource_HEADERS})

include_directories(
	${FFMPEG_INCLUDE_DIRS}
	${DShowPath})

SET(DSHOW_LIBRARY optimized ${DShowLib} debug ${DShowLibD})

target_link_libraries(obs-virtualsource
	${FFMPEG_LIBRARIES}
	${DSHOW_LIBRARY}
	winmm
	Strmiids
	)

if(MSVC)
	set(CMAKE_EXE_LINKER_FLAGS
      "${CMAKE_EXE_LINKER_FLAGS} /DEF:virtual-source.def /NODEFAULTLIB")
	foreach(t EXE SHARED MODULE)
		set(CMAKE_${t}_LINKER_FLAGS "${CMAKE_${t}_LINKER_FLAGS} /OPT:REF")
		set(CMAKE_${t}_LINKER_FLAGS_DEBUG "${CMAKE_${t}_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		set(CMAKE_${t}_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_${t}_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO /PDBSTRIPPED")
	endforeach()

    foreach(var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
      if(${var} MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MT" ${var} "${${var}}")
      endif()
    endforeach()
endif()

set_target_properties(obs-virtualsource
	PROPERTIES
	VERSION "2.1.1"
	PRODUCTNAME "OBS Virtualcam Plugin")
