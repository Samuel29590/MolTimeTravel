Class {
	#name : #MolGroundMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolGroundMemento >> redo [

	self restoreValues.
]

{ #category : #'undo - undo' }
MolGroundMemento >> save: aFighter [

	componentClass := aFighter class.
	componentName := aFighter componentName.
]

{ #category : #'undo - undo' }
MolGroundMemento >> undo [

	self restoreValues
]
