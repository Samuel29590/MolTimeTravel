Class {
	#name : #MAFeedingPointMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'position',
		'capacity'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAFeedingPointMemento >> getCapacity [

	^ capacity 
]

{ #category : #accessing }
MAFeedingPointMemento >> getPosition [

	^ position
]

{ #category : #'undo - undo' }
MAFeedingPointMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAFeedingPointMemento >> save: aFeedingPoint [

	componentClass := aFeedingPoint class.
	componentName := aFeedingPoint componentName.
	position := aFeedingPoint getPosition.
	capacity  := aFeedingPoint getCapacity.
]

{ #category : #'undo - undo' }
MAFeedingPointMemento >> undo [

	self restoreValues
]