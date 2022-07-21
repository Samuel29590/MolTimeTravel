Class {
	#name : #MAAntMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ageInMs',
		'position',
		'stage'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #accessing }
MAAntMemento >> getAgeInMs [

	^ ageInMs
]

{ #category : #accessing }
MAAntMemento >> getPosition [

	^ position
]

{ #category : #accessing }
MAAntMemento >> getStage [

	^ stage
]

{ #category : #'undo - undo' }
MAAntMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAAntMemento >> save: anAnt [

	componentClass := anAnt class.
	componentName := anAnt componentName.

	position := anAnt getPosition.
	ageInMs := anAnt getAgeInMs.
	anAnt getStage ifNil:[stage:= nil] ifNotNil: [ 
	stage := anAnt getStage class -> anAnt getStage componentName ].
]

{ #category : #'undo - undo' }
MAAntMemento >> undo [

	self restoreValues
]
