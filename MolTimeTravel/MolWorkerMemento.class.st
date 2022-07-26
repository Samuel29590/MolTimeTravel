Class {
	#name : #MolWorkerMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'oldPositions',
		'phase'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolWorkerMemento >> getOldPositions [

	^ oldPositions
]

{ #category : #accessing }
MolWorkerMemento >> getPhase [

	^ phase
]

{ #category : #'undo - undo' }
MolWorkerMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolWorkerMemento >> save: aWorker [

	componentReference := MolComponentReference newFrom: aWorker.
	
	phase := aWorker getPhase.
	oldPositions := aWorker getOldPositions copy
]

{ #category : #'undo - undo' }
MolWorkerMemento >> undo [

	self restoreValues
]
