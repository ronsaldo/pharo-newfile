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

typedef enum NewFileCreationDisposition_e
{
    NewFileCreationDispositionCreateNew = 1,
    NewFileCreationDispositionCreateAlways,
    NewFileCreationDispositionOpenExisting,
    NewFileCreationDispositionOpenAlways,
    NewFileCreationDispositionTruncateExisting,
} NewFileCreationDisposition_t;

typedef enum NewFileOpenFlags_e
{
    NewFileOpenFlagsNone = 0,
    NewFileOpenFlagsAppend = 1<<0,
} NewFileOpenFlags_t;

typedef enum NewFileSeekMode_e
{
    NewFileSeekModeSet = 0,
    NewFileSeekModeCurrent,
    NewFileSeekModeEnd,
} NewFileSeekMode_t;

typedef enum NewFileMemMapProtection_e
{
    NewFileMemMapProtectionReadOnly = 0,
    NewFileMemMapProtectionReadWrite,
} NewFileMemMapProtection_t;
/**
 * Opens a file.
 */
PHARO_NEWFILE_EXPORT NewFile_t *NewFile_open(const char *path, NewFileOpenMode_t mode, NewFileCreationDisposition_t creationDisposition, NewFileOpenFlags_t flags);

/*+
 * Closes the file
 */
PHARO_NEWFILE_EXPORT void NewFile_close(NewFile_t *file);

/*+
 * Get file size
  */
PHARO_NEWFILE_EXPORT int64_t NewFile_getSize(NewFile_t *file);

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
PHARO_NEWFILE_EXPORT int64_t NewFile_read(NewFile_t *file, void * buffer, size_t bufferOffset, size_t readSize);

/**
 * Write
 */
PHARO_NEWFILE_EXPORT int64_t NewFile_write(NewFile_t *file, const void * buffer, size_t bufferOffset, size_t writeSize);

/**
 * Read at offset
 */
PHARO_NEWFILE_EXPORT int64_t NewFile_readAtOffset(NewFile_t *file, void * buffer, size_t bufferOffset, size_t readSize, uint64_t offset);

/**
 * Write
 */
PHARO_NEWFILE_EXPORT int64_t NewFile_writeAtOffset(NewFile_t *file, const void * buffer, size_t bufferOffset, size_t writeSize, uint64_t offset);

/**
 * Memory Map
 */
PHARO_NEWFILE_EXPORT void * NewFile_memoryMap(NewFile_t *file, NewFileMemMapProtection_t protection);

/**
 * Memory Unmap
 */
PHARO_NEWFILE_EXPORT void * NewFile_memoryUnmap(NewFile_t *file, NewFileMemMapProtection_t protection);

#endif // PHARO_NEWFILE_H
