Class {
	#name : #MolFeedingPointMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'capacity',
		'position'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolFeedingPointMemento >> getCapacity [

	^ capacity 
]

{ #category : #accessing }
MolFeedingPointMemento >> getPosition [

	^ position
]

{ #category : #'undo - undo' }
MolFeedingPointMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolFeedingPointMemento >> save: aFeedingPoint [

	componentReference := MolComponentReference newFrom: aFeedingPoint.
	
	position := aFeedingPoint getPosition.
	capacity  := aFeedingPoint getCapacity.
]

{ #category : #'undo - undo' }
MolFeedingPointMemento >> undo [

	self restoreValues
]
