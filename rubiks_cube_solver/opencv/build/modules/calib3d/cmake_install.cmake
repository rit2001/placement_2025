# Install script for directory: /Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/calib3d

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "libs" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY OPTIONAL FILES
    "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib/libopencv_calib3d.4.12.0.dylib"
    "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib/libopencv_calib3d.412.dylib"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_calib3d.4.12.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_calib3d.412.dylib"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      execute_process(COMMAND /usr/bin/install_name_tool
        -delete_rpath "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib"
        -add_rpath "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/install/lib"
        "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" -x "${file}")
      endif()
    endif()
  endforeach()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib/libopencv_calib3d.dylib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/calib3d/include/opencv2/calib3d.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/calib3d" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/calib3d/include/opencv2/calib3d/calib3d.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/calib3d" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/calib3d/include/opencv2/calib3d/calib3d_c.h")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/modules/calib3d/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
