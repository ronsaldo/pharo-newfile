"
I am a strategy for for choosing between the old and new file implementation.
"
Class {
	#name : 'FileAPI',
	#superclass : 'Object',
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'as yet unclassified' }
FileAPI class >> currentFileClass [
	^ self useNewFile ifTrue: [ NewFile ] ifFalse: [ OldFile ]
]

{ #category : 'as yet unclassified' }
FileAPI class >> deleteFile: path [
	^ self currentFileClass deleteFile: path
]

{ #category : 'as yet unclassified' }
FileAPI class >> exists: path [
	^ self currentFileClass exists: path
]

{ #category : 'as yet unclassified' }
FileAPI class >> openAlways: path [
	^ self currentFileClass openAlways: path
]

{ #category : 'as yet unclassified' }
FileAPI class >> openCreateAlways: path [
	^ self currentFileClass openCreateAlways: path
]

{ #category : 'as yet unclassified' }
FileAPI class >> openReadOnly: path [
	^ self currentFileClass openReadOnly: path
]

{ #category : 'as yet unclassified' }
FileAPI class >> useNewFile [
	^ NewFile primitiveIsAvailable
]
