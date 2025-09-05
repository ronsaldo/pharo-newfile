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

{ #category : 'accessing' }
NewDirectory class >> ffiLibrary [
	
	^ NewFileLibrary 
	
]

{ #category : 'finalization' }
NewDirectory class >> finalizeResourceData: aHandle [
	aHandle isNull ifTrue: [ ^ self ].
	self primitiveClose: aHandle.
	aHandle beNull
]

{ #category : 'protocol' }
NewDirectory class >> open: path [
	| directory |
	directory := self primitiveOpen: path.
	directory isNull ifTrue: [ ^ nil ].
	
	^ directory autoRelease
]

{ #category : 'as yet unclassified' }
NewDirectory class >> primitiveClose: aDirectory [
	^ self ffiCall: #(void NewDirectory_close(void *aDirectory))
]

{ #category : 'as yet unclassified' }
NewDirectory class >> primitiveOpen: path [
	^ self ffiCall: #(NewDirectory NewDirectory_open(String path))
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
NewDirectory >> next [
	| nextName |
	nextName := self primitiveNext.
	nextName isEmpty ifTrue: [^ nil ].	
	^ nextName 
]

{ #category : 'private' }
NewDirectory >> primitiveClose [
	^ self ffiCall: #(void NewDirectory_close(self))
]

{ #category : 'private' }
NewDirectory >> primitiveNext [
	^ self ffiCall: #(String NewDirectory_next(self))
]

{ #category : 'private' }
NewDirectory >> rewind [
	^ self ffiCall: #(String NewDirectory_rewind(self))
]
