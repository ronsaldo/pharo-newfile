"
A NewBinaryFileStreamTest is a test class for testing the behavior of NewBinaryFileStream
"
Class {
	#name : 'NewBinaryFileStreamTest',
	#superclass : 'TestCase',
	#category : 'NewFiles-Tests',
	#package : 'NewFiles-Tests'
}

{ #category : 'private' }
NewBinaryFileStreamTest >> fileStreamForFileNamed: fileName [
]

{ #category : 'private' }
NewBinaryFileStreamTest >> killTestFile [
	(NewFile exists: 'testFile') ifTrue: [
		NewFile deleteFile: 'testFile'
	].

]

{ #category : 'running' }
NewBinaryFileStreamTest >> setUp [
	self killTestFile.
	
]

{ #category : 'running' }
NewBinaryFileStreamTest >> tearDown [ 
	self killTestFile.
	
]
