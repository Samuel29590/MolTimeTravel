Class {
	#name : #MolHardwareMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolHardwareMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolHardwareMemento >> save: anHardware [

	componentClass := anHardware class.
	componentName := anHardware componentName.
]

{ #category : #'undo - undo' }
MolHardwareMemento >> undo [

	self restoreValues
]
