"
I am the new file ffi library.
"
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

{ #category : 'accessing - platform' }
NewFileLibrary >> unix32LibraryName [

	^ FFIUnix32LibraryFinder findAnyLibrary: #(
		'libPharoNewFile.so')
]

{ #category : 'accessing - platform' }
NewFileLibrary >> unix64LibraryName [

	^ FFIUnix64LibraryFinder findAnyLibrary: #(
		'libPharoNewFile.so')
]

{ #category : 'accessing - platform' }
NewFileLibrary >> win32LibraryName [
	^ FFIWindowsLibraryFinder findAnyLibrary: #('PharoNewFile.dll')
	
]
