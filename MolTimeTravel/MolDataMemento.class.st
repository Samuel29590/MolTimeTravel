Class {
	#name : #MolDataMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'accuracy'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolDataMemento >> getAccuracy [

	^ accuracy 
]

{ #category : #'undo - undo' }
MolDataMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolDataMemento >> save: aData [

	componentClass := aData class.
	componentName := aData componentName.

	accuracy := aData accuracy.
]

{ #category : #'undo - undo' }
MolDataMemento >> undo [

	self restoreValues
]
