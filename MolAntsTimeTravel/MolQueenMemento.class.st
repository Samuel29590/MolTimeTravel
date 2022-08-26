Class {
	#name : #MolQueenMemento,
	#superclass : #MolComponentMemento,
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MolQueenMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolQueenMemento >> save: aQueen [

	componentReference := MolComponentReference newFrom: aQueen.
]

{ #category : #'undo - undo' }
MolQueenMemento >> undo [

	self restoreValues
]
