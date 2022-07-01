Class {
	#name : #MAQueenMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAnts
}

{ #category : #'undo - undo' }
MAQueenMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAQueenMemento >> save: anQueen [

	componentClass := anQueen class.
	componentName := anQueen componentName
]

{ #category : #'undo - undo' }
MAQueenMemento >> undo [

	self restoreValues
]
