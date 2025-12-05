"
I provide legacy file plugin support.
"
Class {
	#name : 'OldDirectory',
	#superclass : 'FFIExternalObject',
	#pools : [
		'NewFileConstants'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'creation and destruction' }
OldDirectory class >> contentsOf: path [
	self shouldBeImplemented
]

{ #category : 'creation and destruction' }
OldDirectory class >> create: path [
	^ File createDirectory: path
]

{ #category : 'creation and destruction' }
OldDirectory class >> open: path [
	self shouldBeImplemented 
]

{ #category : 'creation and destruction' }
OldDirectory class >> removeEmpty: path [
	^ File deleteDirectory: path
]
