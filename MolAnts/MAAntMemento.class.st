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
MAAntMemento >> ageInMs [

	^ ageInMs
]

{ #category : #accessing }
MAAntMemento >> position [

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
	position := anAnt position.
	ageInMs := anAnt ageInMs.
	stage := (anAnt getStage class)->(anAnt getStage componentName)
]

{ #category : #accessing }
MAAntMemento >> stage [

	^ stage
]

{ #category : #'undo - undo' }
MAAntMemento >> undo [

	self restoreValues
]
