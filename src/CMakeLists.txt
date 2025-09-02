set(PharoNewFiles_Sources
    UnixFile.c
    Win32File.c
)

add_library(PharoNewFile SHARED ${PharoNewFiles_Sources})