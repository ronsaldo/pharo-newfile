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

{ #category : 'initialization' }
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

{ #category : 'initialization' }
NewFile >> primitiveClose [
	^ self ffiCall: #(void NewFile_close(self))
]

{ #category : 'initialization' }
NewFile >> primitiveMemoryMapWithProtection: protection [
	^ self ffiCall: #(void* NewFile_memoryMap(self, int protection))
]

{ #category : 'initialization' }
NewFile >> primitiveMemoryUnmap [
	^ self ffiCall: #(void NewFile_memoryUnmap(self))
]

{ #category : 'initialization' }
NewFile >> readInto: buffer [
	^ self readInto: buffer offset: 0 withSize: buffer size
]

{ #category : 'initialization' }
NewFile >> readInto: buffer offset: bufferOffset withSize: readSize [
	^ self ffiCall: #(int64 NewFile_read(self, void* buffer, size_t bufferOffset, size_t readSize))
]

{ #category : 'initialization' }
NewFile >> readInto: buffer withSize: readSize [
	^ self readInto: buffer offset: 0 withSize: readSize
]

{ #category : 'initialization' }
NewFile >> readOnlyMemoryMap [
	^ self memoryMapWithProtection: NewFileMemMapProtectionReadOnly
]

{ #category : 'initialization' }
NewFile >> seek: offset mode: seekMode [
	^ self ffiCall: #(int64 NewFile_seek(self, int64 offset, int seekMode))
]

{ #category : 'initialization' }
NewFile >> size [
	^ self ffiCall: #(int64 NewFile_getSize(self))
]

{ #category : 'initialization' }
NewFile >> tell [
	^ self ffiCall: #(int64 NewFile_tell(self))
]

{ #category : 'as yet unclassified' }
NewFile >> unmapView: aFileMemoryMappingView [
	self primitiveMemoryUnmap.
	aFileMemoryMappingView unmapped
]

{ #category : 'initialization' }
NewFile >> writeFrom: dataBuffer [
	^ self writeFrom: dataBuffer offset: 0 withSize: dataBuffer size
]

{ #category : 'initialization' }
NewFile >> writeFrom: buffer offset: bufferOffset withSize: bufferSize [
	^ self ffiCall: #(int64 NewFile_write(self, void* buffer, size_t bufferOffset, size_t bufferSize))
]

{ #category : 'initialization' }
NewFile >> writeFrom: buffer withSize: bufferSize [
	^ self writeFrom: buffer offset: 0 withSize: bufferSize
]
