#ifndef PHARO_NEWFILE_H
#define PHARO_NEWFILE_H

#include <stddef.h>
#include <stdint.h>

typedef void * NewFileHandle;

typedef struct NewFile_s NewFile_t;

typedef enum NewFileOpenMode_e
{
    NewFileOpenModeReadOnly = 0,
    NewFileOpenModeReadWrite,
    NewFileOpenModeAppend
} NewFileOpenMode_t;

typedef enum NewFileSeekMode_e
{
    NewFileSeekModeSet = 0,
    NewFileSeekModeCurrent,
    NewFileSeekModeEnd,
} NewFileSeekMode_t;

/**
 * Opens a file.
 */
NewFile_t *newfile_open(const char *path, NewFileOpenMode_t mode);

/*+
 * Closes the file
 */
void newfile_close(NewFile_t *file);

/*+
 * Seeks
 */
void newfile_seek(NewFile_t *file, int64_t offset, NewFileSeekMode_t seekMode);

/*+
 * Tell
 */
int64_t newfile_tell(NewFile_t *file);

/**
 * Read
 */
int64_t newfile_read(NewFile_t *file, void * buffer, size_t bufferSize);

/**
 * Write
 */
int64_t newfile_write(NewFile_t *file, void * buffer, size_t bufferSize);

#endif // PHARO_NEWFILE_H
