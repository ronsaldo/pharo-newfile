set(PharoNewFiles_Sources
    UnixFile.c
    Win32File.c
)

add_library(PharoNewFiles SHARED ${PharoNewFiles_Sources})