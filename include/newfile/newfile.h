#ifndef PHARO_NEWFILE_H
#define PHARO_NEWFILE_H

#include <stddef.h>
#include <stdint.h>

#ifdef _WIN32
#   ifdef PHARO_NEWFILE_BUILD
#       define PHARO_NEWFILE_EXPORT __declspec(dllexport)
#   else
#       define PHARO_NEWFILE_EXPORT __declspec(dllimport)
#   endif
#else
#   define PHARO_NEWFILE_EXPORT
#endif

typedef void * NewFileHandle;

typedef struct NewFile_s NewFile_t;

typedef enum NewFileOpenMode_e
{
    NewFileOpenModeReadOnly = 0,
    NewFileOpenModeWriteOnly,
    NewFileOpenModeReadWrite,
} NewFileOpenMode_t;

typedef enum NewFileOpenFlags_e
{
    NewFileOpenFlagsCreate = 1<<0,
    NewFileOpenFlagsTruncate = 1<<1,
    NewFileOpenFlagsAppend = 1<<2,
} NewFileOpenFlags_t;

typedef enum NewFileSeekMode_e
{
    NewFileSeekModeSet = 0,
    NewFileSeekModeCurrent,
    NewFileSeekModeEnd,
} NewFileSeekMode_t;

/**
 * Opens a file.
 */
PHARO_NEWFILE_EXPORT NewFile_t *NewFile_open(const char *path, NewFileOpenMode_t mode, NewFileOpenFlags_t flags);

/*+
 * Closes the file
 */
PHARO_NEWFILE_EXPORT void NewFile_close(NewFile_t *file);

/*+
 * Seeks
 */
PHARO_NEWFILE_EXPORT void NewFile_seek(NewFile_t *file, int64_t offset, NewFileSeekMode_t seekMode);

/*+
 * Tell
 */
PHARO_NEWFILE_EXPORT int64_t NewFile_tell(NewFile_t *file);

/**
 * Read
 */
PHARO_NEWFILE_EXPORT int64_t NewFile_read(NewFile_t *file, void * buffer, size_t bufferSize);

/**
 * Write
 */
PHARO_NEWFILE_EXPORT int64_t NewFile_write(NewFile_t *file, void * buffer, size_t bufferSize);

#endif // PHARO_NEWFILE_H
