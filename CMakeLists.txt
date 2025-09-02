cmake_minimum_required(VERSION 3.5)
project(PharoNewFiles)

# Add the current directory.
include_directories(
.
"${PROJECT_SOURCE_DIR}/include"
)

add_subdirectory(src)