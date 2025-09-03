Class {
	#name : 'NewFileConstants',
	#superclass : 'SharedPool',
	#classVars : [
		'NewFileOpenFlagsAppend',
		'NewFileOpenFlagsCreate',
		'NewFileOpenFlagsTruncate',
		'NewFileOpenModeReadOnly',
		'NewFileOpenModeReadWrite',
		'NewFileOpenModeWriteOnly',
		'NewFileSeekModeCurrent',
		'NewFileSeekModeEnd',
		'NewFileSeekModeSet'
	],
	#category : 'NewFiles',
	#package : 'NewFiles'
}

{ #category : 'class initialization' }
NewFileConstants class >> initialize [
	NewFileOpenModeReadOnly := 0.
	NewFileOpenModeWriteOnly := 1.
	NewFileOpenModeReadWrite := 2.
	
	NewFileOpenFlagsCreate := 1<<0.
	NewFileOpenFlagsTruncate := 1<<1.
	NewFileOpenFlagsAppend := 1<<2.

	NewFileSeekModeSet := 0.
	NewFileSeekModeCurrent := 1.
	NewFileSeekModeEnd := 2.
	
]
