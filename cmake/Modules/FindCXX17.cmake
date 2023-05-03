# - Finds if the compiler has C++17 support
# This module can be used to detect compiler flags for using C++17, and checks
# a small subset of the language.
#
# The following variables are set:
#   CXX17_FLAGS - flags to add to the CXX compiler for C++17 support
#   CXX17_FOUND - true if the compiler supports C++17
#

if(CXX17_FLAGS)
    set(CXX17_FOUND TRUE)
    return()
endif()

include(CheckCXXSourceCompiles)

if(MSVC)
    set(CXX17_FLAG_CANDIDATES
	    " "
        )
else()
    set(CXX17_FLAG_CANDIDATES
        #gcc
        "-std=gnu++17"
        "-std=gnu++0x"
        #Gnu and Intel Linux
        "-std=c++17"
        "-std=c++0x"
        #Microsoft Visual Studio, and everything that automatically accepts C++17
        " "
        #Intel windows
        "/Qstd=c++17"
        "/Qstd=c++0x"
        )
endif()

set(CXX17_TEST_SOURCE
"
int main()
{
    int n[] = {4,7,6,1,2};
	int r;
	auto f = [&](int j) { r = j; };

    for (auto i : n)
        f(i);
    return 0;
}
")

foreach(FLAG ${CXX17_FLAG_CANDIDATES})
    set(SAFE_CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    set(CMAKE_REQUIRED_FLAGS "${FLAG}")
    unset(CXX17_FLAG_DETECTED CACHE)
    message(STATUS "Try C++17 flag = [${FLAG}]")
    check_cxx_source_compiles("${CXX17_TEST_SOURCE}" CXX17_FLAG_DETECTED)
    set(CMAKE_REQUIRED_FLAGS "${SAFE_CMAKE_REQUIRED_FLAGS}")
    if(CXX17_FLAG_DETECTED)
        set(CXX17_FLAGS_INTERNAL "${FLAG}")
        break()
    endif(CXX17_FLAG_DETECTED)
endforeach(FLAG ${CXX17_FLAG_CANDIDATES})

set(CXX17_FLAGS "${CXX17_FLAGS_INTERNAL}" CACHE STRING "C++17 Flags")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CXX17 DEFAULT_MSG CXX17_FLAGS)
mark_as_advanced(CXX17_FLAGS)
