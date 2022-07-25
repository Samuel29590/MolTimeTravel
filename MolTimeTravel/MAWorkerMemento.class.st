Class {
	#name : #MAWorkerMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'oldPositions',
		'phase'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MAWorkerMemento >> getOldPositions [

	^ oldPositions
]

{ #category : #accessing }
MAWorkerMemento >> getPhase [

	^ phase
]

{ #category : #'undo - undo' }
MAWorkerMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAWorkerMemento >> save: aWorker [

	componentClass := aWorker class.
	componentName := aWorker componentName.
	phase := aWorker getPhase.
	oldPositions := aWorker getOldPositions copy
]

{ #category : #'undo - undo' }
MAWorkerMemento >> undo [

	self restoreValues
]
