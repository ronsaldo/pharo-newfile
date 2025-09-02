#ifndef PHARO_NEWFILE_H
#define PHARO_NEWFILE_H

#include <stddef.h>
#include <stdint.h>

typedef void * NewFileHandle;

typedef struct NewFile_s NewFile_t;

NewFile_t *pharo_newfile_open(const char *path);
void pharo_newfile_close(NewFile_t *file);

#endif // PHARO_NEWFILE_H
