#include "newfile/NewFile.h"

#ifdef _WIN32
#include <stdlib.h>

PHARO_NEWFILE_EXPORT NewFile_t *
NewFile_open(const char *path, NewFileOpenMode_t mode, NewFileOpenFlags_t flags)
{
    abort();
}

PHARO_NEWFILE_EXPORT void NewFile_close(NewFile_t *file)
{
    abort();
}

PHARO_NEWFILE_EXPORT void
NewFile_seek(NewFile_t *file, int64_t offset, NewFileSeekMode_t seekMode)
{
    abort();
}

PHARO_NEWFILE_EXPORT int64_t NewFile_tell(NewFile_t *file)
{
    abort();
}

PHARO_NEWFILE_EXPORT int64_t NewFile_read(NewFile_t *file, void * buffer, size_t bufferSize)
{
    abort();
}

PHARO_NEWFILE_EXPORT int64_t NewFile_write(NewFile_t *file, void * buffer, size_t bufferSize)
{
    abort();
}

#endif
