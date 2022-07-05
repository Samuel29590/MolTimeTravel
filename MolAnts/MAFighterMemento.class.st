Class {
	#name : #MAFighterMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAnts
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
