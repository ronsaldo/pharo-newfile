Class {
	#name : 'NewFileLibrary',
	#superclass : 'FFILibrary',
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'accessing - platform' }
NewFileLibrary >> macLibraryName [
	^ FFIMacLibraryFinder
		findAnyLibrary: #('libPharoNewFile.dylib')
]
