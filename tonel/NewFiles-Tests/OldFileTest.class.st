Class {
	#name : 'OldFileTest',
	#superclass : 'TestCase',
	#category : 'NewFiles-Tests',
	#package : 'NewFiles-Tests'
}

{ #category : 'tests' }
OldFileTest >> testHelloWorld [
	| path text file buffer decodedText |
	path := 'test.txt'.
	text := 'Hello World'.
	
	file := OldFile openCreateNewAlways: path.
	file writeFrom: text utf8Encoded.
	file close.
	
	file := OldFile openReadOnly: path.
	buffer := ByteArray new: file size.
	file readInto: buffer.
	file close.
	
	decodedText := buffer utf8Decoded.
	self assert: decodedText equals: text.
	
	OldFile deleteFile: path.
]
