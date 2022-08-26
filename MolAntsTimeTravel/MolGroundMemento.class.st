Class {
	#name : #MolGroundMemento,
	#superclass : #MolComponentMemento,
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MolGroundMemento >> redo [

	self restoreValues.
]

{ #category : #'undo - undo' }
MolGroundMemento >> save: aGround [

	componentReference := MolComponentReference newFrom: aGround.
]

{ #category : #'undo - undo' }
MolGroundMemento >> undo [

	self restoreValues
]
