Class {
	#name : #MolFighterMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolFighterMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolFighterMemento >> save: aFighter [

	componentClass := aFighter class.
	componentName := aFighter componentName.
]

{ #category : #'undo - undo' }
MolFighterMemento >> undo [

	self restoreValues
]
