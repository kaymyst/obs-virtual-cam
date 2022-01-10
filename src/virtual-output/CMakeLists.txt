cmake_minimum_required(VERSION 3.5)
project(obs-virtualoutput)

find_package(FFmpeg COMPONENTS avutil avfilter REQUIRED)

set(CMAKE_PREFIX_PATH "${QTDIR}")
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5Core REQUIRED)
find_package(Qt5Widgets REQUIRED)

set(LIBOBS_INCLUDE_DIR "LIBOBS_INCLUDE-NOTFOUND" CACHE FILEPATH "LIBOBS PATH")
	if(OBS_FRONTEND_LIB EQUAL "LIBOBS_INCLUDE-NOTFOUND")
		message(FATAL_ERROR "Could not find OBS include Path")
	endif()

set(LIBOBS_LIB "LIBOBS_LIB-NOTFOUND" CACHE FILEPATH "OBS library")
	if(OBS_FRONTEND_LIB EQUAL "LIBOBS_LIB-NOTFOUND")
		message(FATAL_ERROR "Could not find OBS library !")
	endif()

set(OBS_FRONTEND_LIB "OBS_FRONTEND_LIB-NOTFOUND" CACHE FILEPATH "OBS frontend library")
	if(OBS_FRONTEND_LIB EQUAL "OBS_FRONTEND_LIB-NOTFOUND")
		message(FATAL_ERROR "Could not find OBS Frontend API\'s library !")
	endif()

set(PTHREAD_LIB "PTHREAD_LIB-NOTFOUND" CACHE FILEPATH "PTHREAD library")
	if(PTHREAD_LIB EQUAL "PTHREAD_LIB-NOTFOUND")
		message(FATAL_ERROR "Could not find PTHREAD library !")
	endif()

set(virtualoutput_SOURCES
	virtual_main.cpp
	virtualoutput.rc
	virtual_output.cpp
	virtual_properties.cpp
	virtual_filter.cpp
	hflip.cpp
	../queue/share_queue_write.cpp
	)

set(virtualoutput_HEADERS
	get_format.h
	virtual_output.h
	virtual_properties.h
	virtual_filter.h
	hflip.h
	../queue/share_queue_write.h
	../queue/share_queue.h
	)

if(WIN32)
	set(OBS_VIRTUALOUTPUT_VERSION_MAJOR 2)
	set(OBS_VIRTUALOUTPUT_VERSION_MINOR 1)
	set(OBS_VIRTUALOUTPUT_VERSION_PATCH 3)
	set(OBS_VIRTUALOUTPUT_VERSION_STRING "2.1.3")
	configure_file(${CMAKE_CURRENT_SOURCE_DIR}/virtualoutput.rc.in ${CMAKE_CURRENT_SOURCE_DIR}/virtualoutput.rc)
endif()

add_library(obs-virtualoutput MODULE
	${virtualoutput_SOURCES}
	${virtualoutput_HEADERS})

include_directories(
	"${LIBOBS_INCLUDE_DIR}/../UI/obs-frontend-api"
	${LIBOBS_INCLUDE_DIR}
	${FFMPEG_INCLUDE_DIRS}
	${Qt5Core_INCLUDES}
	${Qt5Widgets_INCLUDES})

target_link_libraries(obs-virtualoutput
	${FFMPEG_LIBRARIES}
	${LIBOBS_LIB}
	${OBS_FRONTEND_LIB}
	${PTHREAD_LIB}
	Qt5::Core
	Qt5::Widgets)

if(MSVC)
	foreach(t EXE SHARED MODULE)
		set(CMAKE_${t}_LINKER_FLAGS "${CMAKE_${t}_LINKER_FLAGS} /OPT:REF /OPT:ICF /d2:-FH4-")
		set(CMAKE_${t}_LINKER_FLAGS_DEBUG "${CMAKE_${t}_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO /d2:-FH4-")
		set(CMAKE_${t}_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_${t}_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO /PDBSTRIPPED /d2:-FH4-")
	endforeach()

	foreach(var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
      if(${var} MATCHES "/MD")
        string(REGEX REPLACE "/MD" "/MD /d2FH4-" ${var} "${${var}}")
      endif()
    endforeach()
endif()
