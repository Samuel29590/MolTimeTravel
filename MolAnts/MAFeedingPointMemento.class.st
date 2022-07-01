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
MAFeedingPointMemento >> capacity [

	^ capacity 
]

{ #category : #accessing }
MAFeedingPointMemento >> position [

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
	position := aFeedingPoint position.
	capacity  := aFeedingPoint capacity.
]

{ #category : #'undo - undo' }
MAFeedingPointMemento >> undo [

	self restoreValues
]
