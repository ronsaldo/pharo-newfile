"
I am a new file. I support different kinds usages:
1) File stream support.
2) File read/write with explicit file offset.
3) Memory mapping.

"
Class {
	#name : 'NewFile',
	#superclass : 'FFIExternalObject',
	#instVars : [
		'mode'
	],
	#pools : [
		'NewFileConstants'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'as yet unclassified' }
NewFile class >> deleteFile: path [
	^ self ffiCall: #(bool NewFile_deleteFile(String path))
]

{ #category : 'public' }
NewFile class >> exists: aPath [
	| file |
	file := self openReadOnly: aPath.
	file ifNil: [ ^ false ].
	file close.
	^ true
]

{ #category : 'accessing' }
NewFile class >> ffiLibrary [
	
	^ NewFileLibrary 
	
]

{ #category : 'finalization' }
NewFile class >> finalizeResourceData: aHandle [
	aHandle isNull ifTrue: [ ^ self ].
	self primitiveClose: aHandle.
	aHandle beNull
]

{ #category : 'as yet unclassified' }
NewFile class >> open: path mode: mode creationDisposition: creationDisposition flags: flags [
	| file |
	file := self primitiveOpen: path mode: mode creationDisposition: creationDisposition flags: flags.
	file isNull ifTrue: [ ^ nil ].
	
	file mode: mode.
	^ file autoRelease
]

{ #category : 'as yet unclassified' }
NewFile class >> openAlways: path [
	^ self open: path mode: NewFileOpenModeReadWrite creationDisposition: NewFileCreationDispositionOpenAlways flags: NewFileOpenFlagsNone
]

{ #category : 'as yet unclassified' }
NewFile class >> openCreateNew: path [
	^ self open: path mode: NewFileOpenModeReadWrite creationDisposition: NewFileCreationDispositionCreateNew flags: NewFileOpenFlagsNone
]

{ #category : 'as yet unclassified' }
NewFile class >> openCreateNewAlways: path [
	^ self open: path mode: NewFileOpenModeReadWrite creationDisposition: NewFileCreationDispositionCreateAlways flags: NewFileOpenFlagsNone
]

{ #category : 'as yet unclassified' }
NewFile class >> openReadOnly: path [
	^ self open: path mode: NewFileOpenModeReadOnly creationDisposition: NewFileCreationDispositionOpenExisting flags: NewFileOpenFlagsNone
]

{ #category : 'as yet unclassified' }
NewFile class >> primitiveClose: aFile [
	^ self ffiCall: #(void NewFile_close(void *aFile))
]

{ #category : 'as yet unclassified' }
NewFile class >> primitiveOpen: path mode: mode creationDisposition: creationDisposition flags: flags [
	^ self ffiCall: #(NewFile NewFile_open(String path, int mode, int creationDisposition, int flags))
]

{ #category : 'accessing' }
NewFile >> atEnd [
	^ self position >= self size
]

{ #category : 'as yet unclassified' }
NewFile >> binaryStream [
	^ NewBinaryFileStream forFile: self forWrite: self isForWrite
]

{ #category : 'initialization' }
NewFile >> close [
	handle isNull ifTrue: [ ^ self ].
	self primitiveClose.
	handle beNull
]

{ #category : 'file api' }
NewFile >> contents [
	| buffer |
	buffer := ByteArray new: self size.
	self readInto: buffer at: 0.
	^ buffer
]

{ #category : 'accessing' }
NewFile >> ffiLibrary [
	
	^ NewFileLibrary 
	
]

{ #category : 'testing' }
NewFile >> isForWrite [
	^ mode = NewFileOpenModeReadWrite
]

{ #category : 'memory mapping' }
NewFile >> memoryMapWithProtection: protection [
	| mappingAddress |
	mappingAddress := self primitiveMemoryMapWithProtection: protection.
	mappingAddress isNull ifTrue: [ ^ nil ].

	^ NewFileMemoryMappingView new
		address: mappingAddress;
		file: self;
		size: self size;
		protection: protection;
		yourself
]

{ #category : 'accessing' }
NewFile >> mode [

	^ mode
]

{ #category : 'accessing' }
NewFile >> mode: anObject [

	mode := anObject
]

{ #category : 'accessing' }
NewFile >> position [
	^ self tell
]

{ #category : 'accessing' }
NewFile >> position: aPosition [
	^ self seek: aPosition mode: NewFileSeekModeSet
]

{ #category : 'private' }
NewFile >> primitiveClose [
	^ self ffiCall: #(void NewFile_close(self))
]

{ #category : 'private' }
NewFile >> primitiveMemoryMapWithProtection: protection [
	^ self ffiCall: #(void* NewFile_memoryMap(self, int protection))
]

{ #category : 'private' }
NewFile >> primitiveMemoryUnmap [
	^ self ffiCall: #(void NewFile_memoryUnmap(self))
]

{ #category : 'file api' }
NewFile >> readInto: buffer [
	^ self readInto: buffer offset: 0 withSize: buffer size
]

{ #category : 'file api' }
NewFile >> readInto: buffer at: fileOffset [
	^ self readInto: buffer offset: 0 withSize: buffer size at: fileOffset
]

{ #category : 'file api' }
NewFile >> readInto: buffer offset: bufferOffset withSize: readSize [
	^ self ffiCall: #(int64 NewFile_read(self, void* buffer, size_t bufferOffset, size_t readSize))
]

{ #category : 'file api' }
NewFile >> readInto: buffer offset: bufferOffset withSize: readSize at: fileOffset [
	^ self ffiCall: #(int64 NewFile_readAtOffset(self, void* buffer, size_t bufferOffset, size_t readSize, uint64 fileOffset))
]

{ #category : 'file api' }
NewFile >> readInto: buffer withSize: readSize [
	^ self readInto: buffer offset: 0 withSize: readSize
]

{ #category : 'memory mapping' }
NewFile >> readOnlyMemoryMap [
	^ self memoryMapWithProtection: NewFileMemMapProtectionReadOnly
]

{ #category : 'memory mapping' }
NewFile >> readWriteMemoryMap [
	^ self memoryMapWithProtection: NewFileMemMapProtectionReadWrite
]

{ #category : 'file api' }
NewFile >> seek: offset mode: seekMode [
	^ self ffiCall: #(int64 NewFile_seek(self, int64 offset, int seekMode))
]

{ #category : 'file api' }
NewFile >> size [
	^ self ffiCall: #(int64 NewFile_getSize(self))
]

{ #category : 'file api' }
NewFile >> tell [
	^ self ffiCall: #(int64 NewFile_tell(self))
]

{ #category : 'file api' }
NewFile >> truncate [
	^ self truncateToSize: 0
]

{ #category : 'file api' }
NewFile >> truncateToSize: newSize [
	^ self ffiCall: #(int64 NewFile_truncate(self, uint64 newSize))
]

{ #category : 'memory mapping' }
NewFile >> unmapView: aFileMemoryMappingView [
	self primitiveMemoryUnmap.
	aFileMemoryMappingView unmapped
]

{ #category : 'file api' }
NewFile >> writeFrom: dataBuffer [
	^ self writeFrom: dataBuffer offset: 0 withSize: dataBuffer size
]

{ #category : 'file api' }
NewFile >> writeFrom: dataBuffer at: fileOffset [
	^ self writeFrom: dataBuffer offset: 0 withSize: dataBuffer size at: fileOffset
]

{ #category : 'file api' }
NewFile >> writeFrom: buffer offset: bufferOffset withSize: bufferSize [
	^ self ffiCall: #(int64 NewFile_write(self, void* buffer, size_t bufferOffset, size_t bufferSize))
]

{ #category : 'file api' }
NewFile >> writeFrom: buffer offset: bufferOffset withSize: bufferSize at: fileOffset [
	^ self ffiCall: #(int64 NewFile_writeAtOffset(self, void* buffer, size_t bufferOffset, size_t bufferSize, int64 fileOffset))
]

{ #category : 'file api' }
NewFile >> writeFrom: buffer withSize: bufferSize [
	^ self writeFrom: buffer offset: 0 withSize: bufferSize
]
