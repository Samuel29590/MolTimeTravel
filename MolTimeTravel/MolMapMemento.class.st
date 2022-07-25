Class {
	#name : #MolMapMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolMapMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolMapMemento >> save: aMap [

	componentClass := aMap class.
	componentName := aMap componentName
]

{ #category : #'undo - undo' }
MolMapMemento >> undo [

	self restoreValues
]
