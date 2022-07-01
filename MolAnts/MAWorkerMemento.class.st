Class {
	#name : #MAWorkerMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'phase',
		'oldPositions'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAWorkerMemento >> oldPositions [

	^ oldPositions
]

{ #category : #accessing }
MAWorkerMemento >> phase [

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
	phase := aWorker phase.
	oldPositions := aWorker oldPositions
]

{ #category : #'undo - undo' }
MAWorkerMemento >> undo [

	self restoreValues
]
