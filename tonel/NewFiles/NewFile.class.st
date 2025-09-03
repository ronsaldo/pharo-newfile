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

{ #category : 'as yet unclassified' }
NewFile class >> open: path mode: mode creationDisposition: creationDisposition flags: flags [
	^ self ffiCall: #(NewFile NewFile_open(String path, int mode, int creationDisposition, int flags))
]

{ #category : 'as yet unclassified' }
NewFile class >> openReadOnly: path [
	^ self open: path mode: NewFileOpenModeReadOnly creationDisposition: NewFileCreationDispositionOpenExisting flags: NewFileOpenFlagsNone
]

{ #category : 'initialization' }
NewFile >> close [
	^ self ffiCall: #(NewFile NewFile_close(self))
]

{ #category : 'accessing' }
NewFile >> ffiLibrary [
	
	^ NewFileLibrary 
	
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
NewFile >> readInto: buffer [
	^ self readInto: buffer withSize: buffer size
]

{ #category : 'initialization' }
NewFile >> readInto: buffer withSize: bufferSize [
	^ self ffiCall: #(int64 NewFile_read(self, void* buffer, size_t bufferSize))
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
