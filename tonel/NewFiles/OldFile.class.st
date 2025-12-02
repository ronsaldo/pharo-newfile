"
I provide legacy file plugin support.
"
Class {
	#name : 'OldFile',
	#superclass : 'FFIExternalObject',
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'primitives - files' }
OldFile class >> checkHandle: handle forPath: path [
	handle ifNil: [ 
		self error: 'Failed to open file ' , path printString
	].
]

{ #category : 'primitives - path' }
OldFile class >> deleteFile: path [
	^ File deleteFile: path
]

{ #category : 'primitives - files' }
OldFile class >> finalizeResourceData: aHandle [
	(File closed: aHandle ) ifTrue: [ ^ self ].
	File close: aHandle
]

{ #category : 'primitives - files' }
OldFile class >> makeWithHandle: handle [
	| file |
	file := self fromHandle: handle.
	^ file autoRelease
]

{ #category : 'primitives - files' }
OldFile class >> openCreateAlways: path [

	| handle |
	handle := File open: path writable: true.
	self checkHandle: handle forPath: path.
	File truncate: handle to: 0.
	^ self makeWithHandle: handle
]

{ #category : 'primitives - files' }
OldFile class >> openReadOnly: path [
	| handle |
	handle := File open: path writable: false.
	self checkHandle: handle forPath: path.
	^ self makeWithHandle: handle
]

{ #category : 'initialization' }
OldFile >> close [
	File close: handle
]
