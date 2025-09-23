# Install script for directory: /Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching

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
    "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib/libopencv_stitching.4.12.0.dylib"
    "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib/libopencv_stitching.412.dylib"
    )
  foreach(file
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_stitching.4.12.0.dylib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_stitching.412.dylib"
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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/lib/libopencv_stitching.dylib")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/autocalib.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/blenders.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/camera.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/exposure_compensate.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/matchers.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/motion_estimators.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/seam_finders.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/timelapsers.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/util.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/util_inl.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/warpers.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching/detail" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/detail/warpers_inl.hpp")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "dev" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv4/opencv2/stitching" TYPE FILE OPTIONAL FILES "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/modules/stitching/include/opencv2/stitching/warpers.hpp")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/ritwikbiswas/Desktop/placement_resources/placement_2026/placement_projects/rubiks_cube_solver/opencv-4.12.0/build/modules/stitching/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
