SET(CMAKE_DL_LIBS "")
SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared -rdata_shared")
SET(CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS "-shared -rdata_shared") 
SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-rpath,")       # -rpath
SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP "")   # : or empty
SET(CMAKE_SHARED_LIBRARY_SONAME_C_FLAG "-Wl,-soname,")
SET(CMAKE_SHARED_LIBRARY_SONAME_CXX_FLAG "-Wl,-soname,")
IF(NOT CMAKE_COMPILER_IS_GNUCC)
  # Set default flags init.
  SET(CMAKE_C_FLAGS_INIT "")
  SET(CMAKE_CXX_FLAGS_INIT "")
  SET(CMAKE_Fortran_FLAGS_INIT "")
  SET(CMAKE_EXE_LINKER_FLAGS_INIT "")
  SET(CMAKE_SHARED_LINKER_FLAGS_INIT "")
  SET(CMAKE_MODULE_LINKER_FLAGS_INIT "")
  
  # If no -o32, -n32, or -64 flag is given, set a reasonable default.
  IF("$ENV{CFLAGS} $ENV{CXXFLAGS} $ENV{LDFLAGS}" MATCHES "-([no]32|64)")
  ELSE("$ENV{CFLAGS} $ENV{CXXFLAGS} $ENV{LDFLAGS}" MATCHES "-([no]32|64)")
    # Check if this is a 64-bit CMake.
    IF(CMAKE_FILE_SELF MATCHES "^CMAKE_FILE_SELF$")
      EXEC_PROGRAM(file ARGS ${CMAKE_COMMAND} OUTPUT_VARIABLE CMAKE_FILE_SELF)
      SET(CMAKE_FILE_SELF "${CMAKE_FILE_SELF}" CACHE INTERNAL
        "Output of file command on ${CMAKE_COMMAND}.")
    ENDIF(CMAKE_FILE_SELF MATCHES "^CMAKE_FILE_SELF$")
    
    # Set initial flags to match cmake executable.
    IF(CMAKE_FILE_SELF MATCHES " 64-bit ")
      SET(CMAKE_C_FLAGS_INIT "-64")
      SET(CMAKE_CXX_FLAGS_INIT "-64")
      SET(CMAKE_Fortran_FLAGS_INIT "-64")
      SET(CMAKE_EXE_LINKER_FLAGS_INIT "-64")
      SET(CMAKE_SHARED_LINKER_FLAGS_INIT "-64")
      SET(CMAKE_MODULE_LINKER_FLAGS_INIT "-64")
    ENDIF(CMAKE_FILE_SELF MATCHES " 64-bit ")
  ENDIF("$ENV{CFLAGS} $ENV{CXXFLAGS} $ENV{LDFLAGS}" MATCHES "-([no]32|64)")
  
  # Set remaining defaults.
  SET(CMAKE_CXX_CREATE_STATIC_LIBRARY
      "<CMAKE_CXX_COMPILER> -ar -o <TARGET> <OBJECTS>")
  SET (CMAKE_CXX_FLAGS_DEBUG_INIT "-g")
  SET (CMAKE_CXX_FLAGS_MINSIZEREL_INIT "-O1 -DNDEBUG")
  SET (CMAKE_CXX_FLAGS_RELEASE_INIT "-O1 -DNDEBUG")
  SET (CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O1")
ENDIF(NOT CMAKE_COMPILER_IS_GNUCC)
INCLUDE(Platform/UnixPaths)

IF(NOT CMAKE_COMPILER_IS_GNUCC)
  SET (CMAKE_C_CREATE_PREPROCESSED_SOURCE "<CMAKE_C_COMPILER> <DEFINES> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
  SET (CMAKE_C_CREATE_ASSEMBLY_SOURCE
    "<CMAKE_C_COMPILER> <DEFINES> <FLAGS> -S <SOURCE>"
    "mv `basename \"<SOURCE>\" | sed 's/\\.[^./]*$$//'`.s <ASSEMBLY_SOURCE>"
    )
ENDIF(NOT CMAKE_COMPILER_IS_GNUCC)

IF(NOT CMAKE_COMPILER_IS_GNUCXX)
  SET (CMAKE_CXX_CREATE_PREPROCESSED_SOURCE "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -E <SOURCE> > <PREPROCESSED_SOURCE>")
  SET (CMAKE_CXX_CREATE_ASSEMBLY_SOURCE
    "<CMAKE_CXX_COMPILER> <DEFINES> <FLAGS> -S <SOURCE>"
    "mv `basename \"<SOURCE>\" | sed 's/\\.[^./]*$$//'`.s <ASSEMBLY_SOURCE>"
    )
ENDIF(NOT CMAKE_COMPILER_IS_GNUCXX)

# Initialize C link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
FOREACH(type SHARED_LIBRARY SHARED_MODULE EXE)
  SET(CMAKE_${type}_LINK_STATIC_C_FLAGS "-Wl,-Bstatic")
  SET(CMAKE_${type}_LINK_DYNAMIC_C_FLAGS "-Wl,-Bdynamic")
ENDFOREACH(type)

# The IRIX linker needs to find transitive shared library dependencies
# in the -L path.
SET(CMAKE_LINK_DEPENDENT_LIBRARY_DIRS 1)
