#include "newfile/NewFile.h"

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <Windows.h>

#include <stdlib.h>

struct NewFile_s
{
    HANDLE fileHandle;
    int memoryMapCount;
    HANDLE memoryMapHandle;
    void *memoyMapAddress;
};

PHARO_NEWFILE_EXPORT NewFile_t *
NewFile_open(const char *path, NewFileOpenMode_t mode, NewFileCreationDisposition_t creationDisposition, NewFileOpenFlags_t flags)
{
    DWORD desiredAccess = 0;
    DWORD shareMode = FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE;
    switch(mode)
    {
    case NewFileOpenModeReadOnly:
        desiredAccess = GENERIC_READ;
        break;
    case NewFileOpenModeWriteOnly:
        desiredAccess = GENERIC_WRITE;
        break;
    case NewFileOpenModeReadWrite:
        desiredAccess = GENERIC_READ | GENERIC_WRITE;
        break;
    default:
        return NULL;
    }

    DWORD dwCreationDisposition;
    switch(creationDisposition)
    {
    case NewFileCreationDispositionCreateNew:
        dwCreationDisposition = CREATE_NEW;
        break;
    case NewFileCreationDispositionCreateAlways:
        dwCreationDisposition = CREATE_ALWAYS;
        break;
    case NewFileCreationDispositionOpenExisting:
        dwCreationDisposition = OPEN_EXISTING;
        break;
    case NewFileCreationDispositionOpenAlways:
        dwCreationDisposition = OPEN_ALWAYS;
        break;
    case NewFileCreationDispositionTruncateExisting:
        dwCreationDisposition = TRUNCATE_EXISTING;
        break;
    default:
        return NULL;
    }

    // TODO: Perform UTF8 wide string conversion.
    HANDLE handle = CreateFileA(path, desiredAccess, shareMode, NULL, dwCreationDisposition, FILE_ATTRIBUTE_NORMAL, NULL);
    if(handle == INVALID_HANDLE_VALUE)
        return NULL;

    NewFile_t *newFile = calloc(1, sizeof(NewFile_t*));
    newFile->fileHandle = handle;
    return newFile;
}

PHARO_NEWFILE_EXPORT void
NewFile_close(NewFile_t *file)
{
    if(!file)
        return;

    if(file->memoryMapCount > 0)
    {
        UnmapViewOfFile(file->memoyMapAddress);
        CloseHandle(file->memoryMapHandle);
    }
    CloseHandle(file->fileHandle);
    free(file);
}

PHARO_NEWFILE_EXPORT int64_t
NewFile_getSize(NewFile_t *file)
{
    if(!file)
        return -1;

    LARGE_INTEGER fileSize = {0};
    if(!GetFileSizeEx(file->fileHandle, &fileSize))
        return -1;

    return fileSize.QuadPart;
}

PHARO_NEWFILE_EXPORT void
NewFile_seek(NewFile_t *file, int64_t offset, NewFileSeekMode_t seekMode)
{
    if(!file)
        return;

    LARGE_INTEGER largeIntegerOffset = {0};
    largeIntegerOffset.QuadPart = offset;

    DWORD moveMethod;
    switch(seekMode)
    {
    case NewFileSeekModeSet:
        moveMethod = FILE_BEGIN;
        break;
    case NewFileSeekModeCurrent:
        moveMethod = FILE_CURRENT;
        break;
    case NewFileSeekModeEnd:
        moveMethod = FILE_END;
        break;
    default:
        abort();
    }

    SetFilePointerEx(file->fileHandle, largeIntegerOffset, NULL, moveMethod);
}

PHARO_NEWFILE_EXPORT int64_t
NewFile_tell(NewFile_t *file)
{
    if(!file)
        return 0;

    LARGE_INTEGER largeIntegerOffset = {0};
    LARGE_INTEGER filePointerPosition = {0};

    if(!SetFilePointerEx(file->fileHandle, largeIntegerOffset, &filePointerPosition, FILE_CURRENT))
        return -1;
    return filePointerPosition.QuadPart;
}

PHARO_NEWFILE_EXPORT int64_t
NewFile_read(NewFile_t *file, void * buffer, size_t bufferOffset, size_t readSize)
{
    if(!file)
        return -1;

    DWORD readBytes = 0;
    if(!ReadFile(file->fileHandle, (char*)buffer + bufferOffset, (DWORD)readSize, &readBytes, NULL))
        return -1;
    return readBytes;
}

PHARO_NEWFILE_EXPORT int64_t
NewFile_write(NewFile_t *file, const void * buffer, size_t bufferOffset, size_t writeSize)
{
    if(!file)
        return -1;

    DWORD writtenBytes = 0;
    if(!WriteFile(file->fileHandle, (const char*)buffer + bufferOffset, (DWORD)writeSize, &writtenBytes, NULL))
        return -1;

    return writtenBytes;
}

PHARO_NEWFILE_EXPORT int64_t
NewFile_readAtOffset(NewFile_t *file, void * buffer, size_t bufferOffset, size_t readSize, uint64_t offset)
{
    if(!file)
        return -1;

    OVERLAPPED overlapped = {0};
    overlapped.Offset = (DWORD)offset;
    overlapped.OffsetHigh = (DWORD)(offset >> 32);

    DWORD readBytes = 0;
    if(!ReadFile(file->fileHandle, (char*)buffer + bufferOffset, (DWORD)readSize, &readBytes, &overlapped))
        return -1;
    return readBytes;
}

PHARO_NEWFILE_EXPORT int64_t
NewFile_writeAtOffset(NewFile_t *file, const void * buffer, size_t bufferOffset, size_t writeSize, uint64_t offset)
{
    if(!file)
        return -1;

    OVERLAPPED overlapped = {0};
    overlapped.Offset = (DWORD)offset;
    overlapped.OffsetHigh = (DWORD)(offset >> 32);

    DWORD writtenBytes = 0;
    if(!WriteFile(file->fileHandle, (const char*)buffer + bufferOffset, (DWORD)writeSize, &writtenBytes, &overlapped))
        return -1;

    return writtenBytes;
}

PHARO_NEWFILE_EXPORT void * NewFile_memoryMap(NewFile_t *file, NewFileMemMapProtection_t protection)
{
    if(!file)
        return NULL;

    if(file->memoryMapCount)
    {
        // TODO: Support changing the permission
        ++file->memoryMapCount;
        return file->memoyMapAddress;
    }

    // Map the file protection
    DWORD flProtect = 0;
    DWORD desiredAccess = 0;
    switch(protection)
    {
    case NewFileMemMapProtectionReadOnly:
        flProtect = PAGE_READONLY;
        desiredAccess = FILE_MAP_READ;
        break;
    case NewFileMemMapProtectionReadWrite:
        flProtect = PAGE_READWRITE;
        desiredAccess = FILE_MAP_WRITE;
        break;
    }

    file->memoryMapHandle = CreateFileMappingA(file->fileHandle, NULL, flProtect, 0, 0, NULL);
    if(!file->memoryMapHandle)
        return NULL;

    file->memoyMapAddress = MapViewOfFile(file->memoryMapHandle, desiredAccess, 0, 0, 0);
    if(!file->memoyMapAddress)
    {
        CloseHandle(file->memoryMapHandle);
        return NULL;
    }

    file->memoryMapCount = 1;

    abort();
    return file->memoyMapAddress;
}
#endif
