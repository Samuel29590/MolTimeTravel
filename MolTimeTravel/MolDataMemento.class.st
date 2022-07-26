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

	componentReference := MolComponentReference newFrom: aData.

	accuracy := aData accuracy.
]

{ #category : #'undo - undo' }
MolDataMemento >> undo [

	self restoreValues
]
