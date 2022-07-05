Class {
	#name : #MAAntMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ageInMs',
		'position',
		'stage'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAAntMemento >> getAgeInMs [

	^ ageInMs
]

{ #category : #accessing }
MAAntMemento >> getPosition [

	^ position
]

{ #category : #'undo - undo' }
MAAntMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAAntMemento >> save: anAnt [

	componentClass := anAnt class.
	componentName := anAnt componentName.
	
	anAnt getPosition ifNil:[
		
	Transcript show: 'An ant save a nil position !!!';cr.
		].
	
	position := anAnt getPosition.
	ageInMs := anAnt getAgeInMs.
	stage := anAnt getStage class -> anAnt getStage componentName
]

{ #category : #accessing }
MAAntMemento >> stage [

	^ stage
]

{ #category : #'undo - undo' }
MAAntMemento >> undo [

	self restoreValues
]
