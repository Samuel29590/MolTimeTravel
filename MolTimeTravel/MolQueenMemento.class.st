Class {
	#name : #MolQueenMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolQueenMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolQueenMemento >> save: anQueen [

	componentClass := anQueen class.
	componentName := anQueen componentName
]

{ #category : #'undo - undo' }
MolQueenMemento >> undo [

	self restoreValues
]
