"
A NewFileTest is a test class for testing the behavior of NewFile
"
Class {
	#name : 'NewFileTest',
	#superclass : 'TestCase',
	#category : 'NewFiles-Tests',
	#package : 'NewFiles-Tests'
}

{ #category : 'tests' }
NewFileTest >> testHelloWorld [
	| path text file buffer decodedText |
	path := 'test.txt'.
	text := 'Hello World'.
	
	file := NewFile openCreateNewAlways: path.
	file writeFrom: text utf8Encoded.
	file close.
	
	file := NewFile openReadOnly: path.
	buffer := ByteArray new: file size.
	file readInto: buffer.
	file close.
	
	decodedText := buffer utf8Decoded.
	self assert: decodedText equals: text.

]
