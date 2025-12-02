"
I provide legacy file plugin support.
"
Class {
	#name : 'OldFile',
	#superclass : 'FFIExternalObject',
	#category : 'NewFiles',
	#package : 'NewFiles'
}

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
OldFile class >> openCreateNewAlways: path [

	| handle |
	handle := File open: path writable: true.
	^ self makeWithHandle: handle
]

{ #category : 'initialization' }
OldFile >> close [
	File close: handle
]
