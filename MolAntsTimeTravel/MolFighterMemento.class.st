Class {
	#name : #MolFighterMemento,
	#superclass : #MolComponentMemento,
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MolFighterMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolFighterMemento >> save: aFighter [

	componentReference := MolComponentReference newFrom: aFighter .
]

{ #category : #'undo - undo' }
MolFighterMemento >> undo [

	self restoreValues
]
