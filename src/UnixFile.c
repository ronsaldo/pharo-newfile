#include "newfile/NewFile.h"

#ifndef _WIN32
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>

struct NewFile_s
{
    int fileDescriptor;
};

PHARO_NEWFILE_EXPORT bool
NewFile_deleteFile(const char *path)
{
    return unlink(path) == 0;
}

NewFile_t *
NewFile_open(const char *path, NewFileOpenMode_t mode, NewFileCreationDisposition_t creationDisposition, NewFileOpenFlags_t flags)
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

    if(flags & NewFileOpenFlagsAppend)
        openFlags |= O_APPEND;

    switch(creationDisposition)
    {
    case NewFileCreationDispositionCreateNew:
        openFlags |= O_CREAT | O_EXCL;
        break;
    case NewFileCreationDispositionCreateAlways:
        openFlags |= O_CREAT | O_TRUNC;
        break;
    case NewFileCreationDispositionOpenExisting:
        break;
    case NewFileCreationDispositionOpenAlways:
        openFlags |= O_CREAT;
        break;
    case NewFileCreationDispositionTruncateExisting:
        openFlags |= O_TRUNC;
        break;
    default:
        break;
    }

    int fd = open(path, openFlags, openMode);
    if(fd < 0)
        return NULL;

    NewFile_t *newFile = calloc(1, sizeof(NewFile_t));
    newFile->fileDescriptor = fd;
    return newFile;
}

void
NewFile_close(NewFile_t *file)
{
    if(!file)
        return;

    close(file->fileDescriptor);
    free(file);
}

int64_t
NewFile_getSize(NewFile_t *file)
{
    if(!file)
        return -1;

    struct stat s;
    if(fstat(file->fileDescriptor, &s))
        return -1;

    return s.st_size;
}

void NewFile_seek(NewFile_t *file, int64_t offset, NewFileSeekMode_t seekMode)
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
NewFile_tell(NewFile_t *file)
{
    if(!file)
        return 0;
    return lseek(file->fileDescriptor, 0, SEEK_CUR);
}

bool
NewFile_truncate(NewFile_t *file, uint64_t newFileSize)
{
    if(!file)
        return -1;
    
    return ftruncate(file->fileDescriptor, newFileSize) == 0;
}

int64_t
NewFile_read(NewFile_t *file, void * buffer, size_t bufferOffset, size_t readSize)
{
    if(!file)
        return -1;

    return read(file->fileDescriptor, (char*)buffer + bufferOffset, readSize);
}

int64_t
NewFile_write(NewFile_t *file, const void * buffer, size_t bufferOffset, size_t writeSize)
{
    if(!file)
        return -1;

    return write(file->fileDescriptor, (const char*)buffer + bufferOffset, writeSize);
}

int64_t
NewFile_readAtOffset(NewFile_t *file, void * buffer, size_t bufferOffset, size_t readSize, uint64_t offset)
{
    if(!file)
        return -1;

    return pread(file->fileDescriptor, (char*)buffer + bufferOffset, readSize, offset);
}

int64_t
NewFile_writeAtOffset(NewFile_t *file, const void * buffer, size_t bufferOffset, size_t writeSize, uint64_t offset)
{
    if(!file)
        return -1;

    return pwrite(file->fileDescriptor, (const char*)buffer + bufferOffset, writeSize, offset);
}

#endif
