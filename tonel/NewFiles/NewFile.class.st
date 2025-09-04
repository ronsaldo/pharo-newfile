Class {
	#name : 'NewFile',
	#superclass : 'FFIExternalObject',
	#pools : [
		'NewFileConstants'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

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
	
	^ file autoRelease
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

{ #category : 'initialization' }
NewFile >> close [
	handle isNull ifTrue: [ ^ self ].
	self primitiveClose.
	handle beNull
]

{ #category : 'accessing' }
NewFile >> ffiLibrary [
	
	^ NewFileLibrary 
	
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
		yourself
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
NewFile >> readInto: buffer offset: bufferOffset withSize: readSize [
	^ self ffiCall: #(int64 NewFile_read(self, void* buffer, size_t bufferOffset, size_t readSize))
]

{ #category : 'file api' }
NewFile >> readInto: buffer withSize: readSize [
	^ self readInto: buffer offset: 0 withSize: readSize
]

{ #category : 'memory mapping' }
NewFile >> readOnlyMemoryMap [
	^ self memoryMapWithProtection: NewFileMemMapProtectionReadOnly
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
NewFile >> writeFrom: buffer offset: bufferOffset withSize: bufferSize [
	^ self ffiCall: #(int64 NewFile_write(self, void* buffer, size_t bufferOffset, size_t bufferSize))
]

{ #category : 'file api' }
NewFile >> writeFrom: buffer withSize: bufferSize [
	^ self writeFrom: buffer offset: 0 withSize: bufferSize
]
