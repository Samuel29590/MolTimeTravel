Class {
	#name : #MolMapMemento,
	#superclass : #MolComponentMemento,
	#category : #MolGPSTimeTravel
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
