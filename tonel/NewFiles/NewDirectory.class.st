"
I am a directory stream.
"
Class {
	#name : 'NewDirectory',
	#superclass : 'FFIExternalObject',
	#pools : [
		'NewFileConstants'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'archive operations' }
NewDirectory class >> contentsOf: path [
	| directory |
	directory := self open: path.
	directory ifNil: [
		self error: 'Failed to open directory ' , path
	].

	^ [ 
		directory contents.
	] ensure: [ 
		directory close
	]
]

{ #category : 'creation and destruction' }
NewDirectory class >> create: path [
	^ self ffiPrimitiveCreate: path
]

{ #category : 'accessing' }
NewDirectory class >> ffiLibrary [
	
	^ NewFileLibrary 
	
]

{ #category : 'private' }
NewDirectory class >> ffiPrimitiveClose: aDirectory [
	^ self ffiCall: #(void NewDirectory_close(void *aDirectory))
]

{ #category : 'creation and destruction' }
NewDirectory class >> ffiPrimitiveCreate: path [
	^ self ffiCall: #(bool NewDirectory_create(String path))
]

{ #category : 'private' }
NewDirectory class >> ffiPrimitiveOpen: path [
	^ self ffiCall: #(NewDirectory NewDirectory_open(String path))
]

{ #category : 'creation and destruction' }
NewDirectory class >> ffiRemoveEmpty: path [
	^ self ffiCall: #(bool NewDirectory_removeEmpty(String path))
]

{ #category : 'finalization' }
NewDirectory class >> finalizeResourceData: aHandle [
	aHandle isNull ifTrue: [ ^ self ].
	self primitiveClose: aHandle.
	aHandle beNull
]

{ #category : 'creation and destruction' }
NewDirectory class >> open: path [
	| directory |
	directory := self primitiveOpen: path.
	directory isNull ifTrue: [ ^ nil ].
	
	^ directory autoRelease
]

{ #category : 'private' }
NewDirectory class >> primitiveClose: aDirectory [
	^ self ffiPrimitiveClose: aDirectory
]

{ #category : 'private' }
NewDirectory class >> primitiveOpen: path [
	^ self ffiPrimitiveOpen: path
]

{ #category : 'creation and destruction' }
NewDirectory class >> removeEmpty: path [
	^ self ffiRemoveEmpty: path
]

{ #category : 'initialization' }
NewDirectory >> close [
	handle isNull ifTrue: [ ^ self ].
	self primitiveClose.
	handle beNull
]

{ #category : 'private' }
NewDirectory >> contents [
	^ Array streamContents: [:out |
		| next	 |
		self rewind.
		[ (next := self next) ~~ nil ] whileTrue: [
			out nextPut: next
		]	
	]
]

{ #category : 'accessing' }
NewDirectory >> ffiLibrary [
	
	^ NewFileLibrary 
	
]

{ #category : 'private' }
NewDirectory >> ffiPrimitiveClose [
	^ self ffiCall: #(void NewDirectory_close(self))
]

{ #category : 'private' }
NewDirectory >> ffiPrimitiveNext [
	^ self ffiCall: #(String NewDirectory_next(self))
]

{ #category : 'private' }
NewDirectory >> ffiPrimitiveRewind [
	^ self ffiCall: #(bool NewDirectory_rewind(self))
]

{ #category : 'private' }
NewDirectory >> next [
	| nextName |
	nextName := self primitiveNext.
	nextName isEmpty ifTrue: [^ nil ].	
	^ nextName 
]

{ #category : 'private' }
NewDirectory >> primitiveClose [
	^ self ffiPrimitiveClose
]

{ #category : 'private' }
NewDirectory >> primitiveNext [
	^ self ffiPrimitiveNext
]

{ #category : 'private' }
NewDirectory >> rewind [
	^ self ffiPrimitiveRewind
]
