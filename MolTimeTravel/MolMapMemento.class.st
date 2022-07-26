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

	componentReference := MolComponentReference newFrom: aMap.
]

{ #category : #'undo - undo' }
MolMapMemento >> undo [

	self restoreValues
]
