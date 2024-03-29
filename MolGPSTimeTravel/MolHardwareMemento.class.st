Class {
	#name : #MolHardwareMemento,
	#superclass : #MolComponentMemento,
	#category : #MolGPSTimeTravel
}

{ #category : #'undo - undo' }
MolHardwareMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolHardwareMemento >> save: anHardware [

	componentReference := MolComponentReference newFrom: anHardware.
]

{ #category : #'undo - undo' }
MolHardwareMemento >> undo [

	self restoreValues
]
