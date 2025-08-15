message("${BoldYellow}-- TOOLCHAIN LOADED${ColourReset}")
set(CROSS_COMPILER ON)
option(CROSS_COMPILER "Enable cross compiler?" ON)
message("${BoldYellow}-- CROSS COMPILE: ${CROSS_COMPILER} ${ColourReset}")

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)
# define target sysroot
if(NOT DEFINED TARGET_SYSROOT OR "${TARGET_SYSROOT}" STREQUAL "")
    set(TARGET_SYSROOT /opt/sysroots/rpi4)
endif()
message("${BoldGreen}-- TARGET_SYSROOT: ${TARGET_SYSROOT} ${ColourReset}")
set(CMAKE_SYSROOT ${TARGET_SYSROOT})
message("${BoldGreen}-- CMAKE_SYSROOT: ${CMAKE_SYSROOT} ${ColourReset}")
# define compiler work (used by custom toolchain)
set(TARGET_ARCHITECTURE aarch64-linux-gnu)
message("${BoldGreen}-- TARGET_ARCHITECTURE: ${TARGET_ARCHITECTURE} ${ColourReset}")
set(CMAKE_C_COMPILER_WORKS ON)
set(CMAKE_C_COMPILER ${TARGET_ARCHITECTURE}-gcc)
message("${BoldGreen}-- CMAKE_C_COMPILER: ${CMAKE_C_COMPILER} ${ColourReset}")
set(CMAKE_CXX_COMPILER_WORKS ON)
set(CMAKE_CXX_COMPILER ${TARGET_ARCHITECTURE}-g++)
message("${BoldGreen}-- CMAKE_CXX_COMPILER: ${CMAKE_CXX_COMPILER} ${ColourReset}")
# define C/CXX flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${CMAKE_SYSROOT}/usr/include -I${CMAKE_SYSROOT}/usr/lib -I${CMAKE_SYSROOT}/usr/include/${TARGET_ARCHITECTURE} -I${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}")
message("${BoldGreen}-- CMAKE_C_FLAGS: ${CMAKE_C_FLAGS} ${ColourReset}")
set(CMAKE_CXX_FLAGS ${CMAKE_C_FLAGS})
message("${BoldGreen}-- CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS} ${ColourReset}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}")
message("${BoldGreen}-- CMAKE_EXE_LINKER_FLAGS: ${CMAKE_EXE_LINKER_FLAGS} ${ColourReset}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS}")

find_package(PkgConfig REQUIRED)
set(PKG_CONFIG_SYSROOT_DIR ${CMAKE_SYSROOT})
set(PKG_CONFIG_LIBDIR ${CMAKE_SYSROOT}/usr/lib/aarch64-linux-gnu/pkgconfig:${CMAKE_SYSROOT}usr/share/pkgconfig)
set(PKG_CONFIG_PATH ${PKG_CONFIG_LIBDIR})

set(QT_COMPILER_FLAGS "-march=armv8-a")
set(QT_COMPILER_FLAGS_RELEASE "-O2 -pipe -DNDEBUG")
set(QT_LINKER_FLAGS "-Wl,-O1 -Wl,--hash-style=gnu -Wl,--as-needed")

# where is the target environment located
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})
# adjust the default behavior of the FIND_XXX() commands:
# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# search headers and libraries in the target environment
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_BUILD_RPATH ${TARGET_SYSROOT})

include(CMakeInitializeConfigs)

function(cmake_initialize_per_config_variable _PREFIX _DOCSTRING)
  if (_PREFIX MATCHES "CMAKE_(C|CXX|ASM)_FLAGS")
    set(CMAKE_${CMAKE_MATCH_1}_FLAGS_INIT "${QT_COMPILER_FLAGS}")
        
    foreach (config DEBUG RELEASE MINSIZEREL RELWITHDEBINFO)
      if (DEFINED QT_COMPILER_FLAGS_${config})
        set(CMAKE_${CMAKE_MATCH_1}_FLAGS_${config}_INIT "${QT_COMPILER_FLAGS_${config}}")
      endif()
    endforeach()
  endif()


  if (_PREFIX MATCHES "CMAKE_(SHARED|MODULE|EXE)_LINKER_FLAGS")
    foreach (config SHARED MODULE EXE)
      set(CMAKE_${config}_LINKER_FLAGS_INIT "${QT_LINKER_FLAGS}")
    endforeach()
  endif()

  _cmake_initialize_per_config_variable(${ARGV})
endfunction()

set(X11_LIBRARIES ${X11_X11_LIB})
set(X11_X11_INCLUDE_PATH ${CMAKE_SYSROOT}/usr/include/X11)
set(X11_X11_LIB ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libX11.so)

set(GL_INC_DIR ${CMAKE_SYSROOT}/usr/include)
set(GL_LIB_DIR ${CMAKE_SYSROOT}:${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/:${CMAKE_SYSROOT}/usr:${CMAKE_SYSROOT}/usr/lib)

set(OPENGL_INCLUDE_DIR ${GL_INC_DIR})
set(OPENGL_opengl_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libOpenGL.so)
set(OPENGL_glx_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libGLX.so)

set(EGL_INCLUDE_DIR ${GL_INC_DIR})
set(EGL_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libEGL.so)

set(GLESv2_INCLUDE_DIR ${GL_INC_DIR})
set(GLESv2_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libGLESv2.so)
set(GLIB_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libGLESv2.so)

set(Libdrm_INCLUDE_DIR ${GL_INC_DIR})
set(Libdrm_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libdrm.so)

set(gbm_INCLUDE_DIR ${GL_INC_DIR})
set(gbm_LIBRARY ${CMAKE_SYSROOT}/usr/lib/${TARGET_ARCHITECTURE}/libgbm.so)