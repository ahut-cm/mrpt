# define_mex_lib(): Declares a usual MEX function:
#-----------------------------------------------------------------------
macro(define_mex_lib name)
	internal_define_mex_lib(${name} 0 ) # is_private = 0
endmacro(define_mex_lib)

# define_mex_lib_private(): Declares a private MEX library, which is stored in /private subfolder
# private libraries are typically used for MEX classes (MEX libraries containing several methods
# which are accessed through a Matlab class in a .m file)
# See: http://es.mathworks.com/help/matlab/matlab_prog/private-functions.html
#-----------------------------------------------------------------------
macro(define_mex_lib_private name)
	internal_define_mex_lib(${name} 1 ) # is_private = 1
endmacro(define_mex_lib_private)

# Implementation of both define_mex_lib() and define_mex_lib_private():
#-----------------------------------------------------------------------------
macro(internal_define_mex_lib   name   is_private)
	INCLUDE(../../../cmakemodules/AssureCMakeRootFile.cmake) # Avoid user mistake in CMake source directory

	IF(${is_private})
		SET(subfolder  private) # Special subfolder private in Matlab (restricted access)
		SET(underscore "_")		# Suffix _ (syntax chosen for private libraries)
	ENDIF(${is_private})

	# 32-bit or 64-bit mex: choose correct suffix depending on system
	if(WIN32)
		if (CMAKE_CL_64)
			SET(MEX_SUFFIX .mexw64)
		else(CMAKE_CL_64)
			SET(MEX_SUFFIX .mexw32)
		endif(CMAKE_CL_64)
	else(WIN32)
		if (CMAKE_SIZEOF_VOID_P MATCHES "8")
			SET(MEX_SUFFIX .mexa64)
		else(CMAKE_SIZEOF_VOID_P MATCHES "8")
			SET(MEX_SUFFIX .mexglx)
		endif (CMAKE_SIZEOF_VOID_P MATCHES "8")
	endif(WIN32)

	# Define MEX library target with specific options
	SET_TARGET_PROPERTIES(${name} PROPERTIES
	PREFIX ""
	SUFFIX "${underscore}${MEX_SUFFIX}"
	DEBUG_POSTFIX "" # Remove DEBUG_POSTFIX in MEX libraries (usually -dbg)
	LIBRARY_OUTPUT_DIRECTORY "${MEX_LIBRARY_OUTPUT_PATH}/${subfolder}"
	RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin/"
	)
endmacro(internal_define_mex_lib)

# define_mex_test(): Declares a MEX executable which allows debug of mexFunction() through main() function:
#-----------------------------------------------------------------------
macro(define_mex_test name)
SET_TARGET_PROPERTIES(${name} PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${MEX_EXECUTABLE_OUTPUT_PATH})
endmacro(define_mex_test name)
