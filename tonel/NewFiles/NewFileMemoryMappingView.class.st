"
I hold metadata about a specific file memory mapped segment.
"
Class {
	#name : 'NewFileMemoryMappingView',
	#superclass : 'Object',
	#instVars : [
		'file',
		'size',
		'address',
		'protection'
	],
	#pools : [
		'NewFileConstants'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'accessing' }
NewFileMemoryMappingView >> address [

	^ address
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> address: anObject [

	address := anObject
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> contents [
	^ address copyFrom: 1 to: size
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> file [

	^ file
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> file: anObject [

	file := anObject
]

{ #category : 'testing' }
NewFileMemoryMappingView >> hasWritePermission [
	^ protection = NewFileMemMapProtectionReadWrite
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> protection [

	^ protection
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> protection: anObject [

	protection := anObject
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> size [

	^ size
]

{ #category : 'accessing' }
NewFileMemoryMappingView >> size: anObject [

	size := anObject
]

{ #category : 'as yet unclassified' }
NewFileMemoryMappingView >> unmap [
	^ file unmapView: self
]

{ #category : 'as yet unclassified' }
NewFileMemoryMappingView >> unmapped [
	address := nil.
	file := nil.
	size := 0.
]
