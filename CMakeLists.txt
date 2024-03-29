cmake_minimum_required(VERSION 3.2)
project(wm)
set(EXE ${CMAKE_PROJECT_NAME})

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Build type is default defined as Release. change it by define -DCMAKE_BUILD_TYPE=Debug as param to cmake")
    set(CMAKE_BUILD_TYPE Release)
endif()

# Download conan.cmake, download taged release - v0.14
if(NOT EXISTS "${CMAKE_SOURCE_DIR}/env/conan.cmake")
   message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
   file(DOWNLOAD "https://github.com/conan-io/cmake-conan/raw/v0.14/conan.cmake"
                 "${CMAKE_SOURCE_DIR}/env/conan.cmake")
endif()
include(env/conan.cmake)

conan_cmake_run(CONANFILE conanfile.txt
                BASIC_SETUP
                BUILD missing)

set(CMAKE_CXX_STANDARD 17)

add_executable(${EXE}
  src/Main.cpp
  src/wm.cpp
  src/wm.h
  )

target_link_libraries(${EXE} ${CONAN_LIBS})

# Tests
set(TEST_FILES
  	src/wm.cpp
  	src/wm.h
	tests/wmTest.cpp
	tests/Main.cpp
	)
set(TEST_NAME ${EXE}Test)

add_executable(${TEST_NAME} ${TEST_FILES})
target_link_libraries(${TEST_NAME} ${CONAN_LIBS})

add_custom_command(TARGET ${EXE} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy_if_different
		${CMAKE_CURRENT_SOURCE_DIR}/tests/res/helloworld.mp4
		$<TARGET_FILE_DIR:${EXE}>
		)

install(TARGETS ${EXE} RUNTIME DESTINATION bin)
# install(FILES tests/res/helloworld.mp4 DESTINATION bin)

install(DIRECTORY ${CMAKE_SOURCE_DIR}/env/
DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
FILES_MATCHING
PATTERN "*.*"
PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)
install()
#FILES ${CMAKE_SOURCE_DIR}/env DESTINATION ${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
