"
I provide legacy file plugin support.
"
Class {
	#name : 'OldFile',
	#superclass : 'Object',
	#instVars : [
		'handle'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'primitives - path' }
OldFile class >> deleteFile: path [
	^ File deleteFile: path
]

{ #category : 'primitives - files' }
OldFile class >> makeWithHandle: handle [
	^ self new handle: handle; yourself
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

{ #category : 'accessing' }
OldFile >> handle [

	^ handle
]

{ #category : 'accessing' }
OldFile >> handle: anObject [

	handle := anObject
]
