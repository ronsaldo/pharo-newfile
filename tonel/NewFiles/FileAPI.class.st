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
FileAPI class >> useNewFile [
	^ NewFile primitiveIsAvailable
]
