Class {
	#name : #MAGroundMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MAGroundMemento >> redo [

	self restoreValues.
]

{ #category : #'undo - undo' }
MAGroundMemento >> save: aFighter [

	componentClass := aFighter class.
	componentName := aFighter componentName.
]

{ #category : #'undo - undo' }
MAGroundMemento >> undo [

	self restoreValues
]
