#include "newfile/NewFile.h"

#ifndef _WIN32
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>

struct NewFile_s
{
    int fileDescriptor;
};

NewFile_t *
newfile_open(const char *path, NewFileOpenMode_t mode, NewFileOpenFlags_t flags)
{
    int openFlags = 0;
    int openMode = 0644;
    switch(mode)
    {
    case NewFileOpenModeReadOnly:
        openFlags = O_RDONLY;
        break;
    case NewFileOpenModeWriteOnly:
        openFlags = O_WRONLY;
        break;
    case NewFileOpenModeReadWrite:
        openFlags = O_RDWR;
        break;
    default:
        return NULL;
    }

    if(flags & NewFileOpenFlagsCreate)
        openFlags |= O_CREAT;
    if(flags & NewFileOpenFlagsTruncate)
        openFlags |= O_TRUNC;
    if(flags & NewFileOpenFlagsAppend)
        openFlags |= O_APPEND;

    int fd = open(path, openFlags, openMode);
    if(fd < 0)
        return NULL;

    NewFile_t *newFile = calloc(1, sizeof(NewFile_t));
    newFile->fileDescriptor = fd;
    return newFile;
}

void
newfile_close(NewFile_t *file)
{
    if(!file)
        return;

    close(file->fileDescriptor);
    free(file);
}

void newfile_seek(NewFile_t *file, int64_t offset, NewFileSeekMode_t seekMode)
{
    int whence = 0;
    switch(seekMode)
    {
    case NewFileSeekModeSet:
        whence = SEEK_SET;
        break;
    case NewFileSeekModeCurrent:
        whence = SEEK_CUR;
        break;
    case NewFileSeekModeEnd:
        whence = SEEK_END;
        break;
    default:
        return;
    }

    lseek(file->fileDescriptor, offset, whence);
}

int64_t
newfile_tell(NewFile_t *file)
{
    if(!file)
        return 0;
    return lseek(file->fileDescriptor, 0, SEEK_CUR);
}

int64_t
newfile_read(NewFile_t *file, void * buffer, size_t bufferSize)
{
    if(!file)
        return -1;

    return read(file->fileDescriptor, buffer, bufferSize);
}

int64_t
newfile_write(NewFile_t *file, void * buffer, size_t bufferSize)
{
    if(!file)
        return -1;

    return write(file->fileDescriptor, buffer, bufferSize);
}


#endif
