cmake_minimum_required(VERSION 2.8)
set(EXE_NAME "stars.out")
set(CMAKE_BUILD_TYPE Debug)
file(GLOB SRCS *.cpp)
add_executable(${EXE_NAME} ${SRCS})
include_directories(
  "${osse_SOURCE_DIR}/libs/collaborate/include/"
  "${osse_SOURCE_DIR}/libs/netcdf/include/"
  "${osse_SOURCE_DIR}/libs/spdlog/include/"
  "${osse_SOURCE_DIR}/libs/sgp4/include/"
  )
target_link_libraries(
  ${EXE_NAME}
  "${osse_BINARY_DIR}/libs/netcdf/src/libosse_netcdf.${LIB_SUFFIX}"
  "${osse_BINARY_DIR}/libs/collaborate/src/libosse_collaborate.${LIB_SUFFIX}"
  )
