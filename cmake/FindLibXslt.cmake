include(FindPackageHandleStandardArgs)
include(GNUInstallDirs)
include(SelectLibraryConfigurations)

foreach(PATH ${CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_INCLUDEDIR}
		${PATH}/libxslt*/${CMAKE_INSTALL_INCLUDEDIR}
	)
	list(APPEND LIBXSLT_INCLUDE_HINTS ${HINTS})
endforeach()

list(
	APPEND
	LIBXSLT_INCLUDE_HINTS
	$ENV{LibXslt_DIR}/${CMAKE_INSTALL_INCLUDEDIR}
)

foreach(PATH $ENV{CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_INCLUDEDIR}
		${PATH}/libxslt*/${CMAKE_INSTALL_INCLUDEDIR}
	)
	list(APPEND LIBXSLT_INCLUDE_HINTS ${HINTS})
endforeach()

foreach(PATH $ENV{PATH})
	file(
		GLOB
		HINTS
		${PATH}/../${CMAKE_INSTALL_INCLUDEDIR}
	)
	list(APPEND LIBXSLT_INCLUDE_HINTS ${HINTS})
endforeach()

file(
	GLOB
	LIBXSLT_INCLUDE_PATHS
	$ENV{HOME}/include
	/usr/local/include
	/opt/local/include
	/usr/include
	${CMAKE_OSX_SYSROOT}/usr/include
)

find_path(
	LIBXSLT_INCLUDE_DIRS
	NAMES
	libxslt/xslt.h
	HINTS
	${LIBXSLT_INCLUDE_HINTS}
	PATHS
	${LIBXSLT_INCLUDE_PATHS}
)

mark_as_advanced(LIBXSLT_INCLUDE_DIRS)

foreach(PATH ${CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_LIBDIR}
		${PATH}/libxslt*/${CMAKE_INSTALL_LIBDIR}
	)
	list(APPEND LIBXSLT_LIBRARY_HINTS ${HINTS})
endforeach()

list(
	APPEND
	LIBXSLT_LIBRARY_HINTS
	$ENV{LibXslt_DIR}/${CMAKE_INSTALL_LIBDIR}
)

foreach(PATH $ENV{CMAKE_PREFIX_PATH})
	file(
		GLOB
		HINTS
		${PATH}/${CMAKE_INSTALL_LIBDIR}
		${PATH}/libxslt*/${CMAKE_INSTALL_LIBDIR}
	)
	list(APPEND LIBXSLT_LIBRARY_HINTS ${HINTS})
endforeach()

foreach(PATH $ENV{PATH})
	file(
		GLOB
		HINTS
		${PATH}/../${CMAKE_INSTALL_LIBDIR}
	)
	list(APPEND LIBXSLT_LIBRARY_HINTS ${HINTS})
endforeach()

file(
	GLOB
	LIBXSLT_LIBRARY_PATHS
	$ENV{HOME}/lib
	/usr/local/lib
	/opt/local/lib
	/usr/lib
)

find_library(
	LIBXSLT_LIBRARY_DEBUG
	NAMES
	libxsltd xsltd
	HINTS
	${LIBXSLT_LIBRARY_HINTS}
	PATHS
	${LIBXSLT_LIBRARY_PATHS}
)
find_library(
	LIBXSLT_LIBRARY_RELEASE
	NAMES
	libxslt xslt
	HINTS
	${LIBXSLT_LIBRARY_HINTS}
	PATHS
	${LIBXSLT_LIBRARY_PATHS}
)

select_library_configurations(LIBXSLT)

find_package_handle_standard_args(
	LibXslt
	FOUND_VAR LIBXSLT_FOUND
	REQUIRED_VARS LIBXSLT_INCLUDE_DIRS LIBXSLT_LIBRARIES
)

if(LIBXSLT_FOUND AND NOT TARGET LibXslt::LibXslt)
	add_library(LibXslt::LibXslt UNKNOWN IMPORTED)
	
	if(LIBXSLT_LIBRARY_RELEASE)
		set_property(TARGET LibXslt::LibXslt APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
		set_target_properties(LibXslt::LibXslt PROPERTIES IMPORTED_LOCATION_RELEASE "${LIBXSLT_LIBRARY_RELEASE}")
	endif()
	
	if(LIBXSLT_LIBRARY_DEBUG)
		set_property(TARGET LibXslt::LibXslt APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
		set_target_properties(LibXslt::LibXslt PROPERTIES IMPORTED_LOCATION_DEBUG "${LIBXSLT_LIBRARY_DEBUG}")
	endif()
	
	set_target_properties(
		LibXslt::LibXslt PROPERTIES
		INTERFACE_INCLUDE_DIRECTORIES "${LIBXSLT_INCLUDE_DIRS}"
	)
endif()
