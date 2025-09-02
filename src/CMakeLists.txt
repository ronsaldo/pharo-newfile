set(PharoNewFiles_Sources
    UnixFile.c
    Win32File.c
)

add_definitions(
    -DPHARO_NEWFILE_BUILD
)
add_library(PharoNewFile SHARED ${PharoNewFiles_Sources})