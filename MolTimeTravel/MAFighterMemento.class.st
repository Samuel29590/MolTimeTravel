Class {
	#name : #MAFighterMemento,
	#superclass : #MAComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MAFighterMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAFighterMemento >> save: aFighter [

	componentClass := aFighter class.
	componentName := aFighter componentName.
]

{ #category : #'undo - undo' }
MAFighterMemento >> undo [

	self restoreValues
]
