Class {
	#name : #MAAntMementoExperimental,
	#superclass : #MAComponentMementoExperimental,
	#instVars : [
		'ageInMs',
		'position'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAAntMementoExperimental >> ageInMs [

	^ ageInMs
]

{ #category : #accessing }
MAAntMementoExperimental >> position [

	^ position
]

{ #category : #'undo - undo' }
MAAntMementoExperimental >> redo [

	self restoreValues.
]

{ #category : #actions }
MAAntMementoExperimental >> save: anAnt [

	componentClass := anAnt class.
	componentName := anAnt componentName.
	position := anAnt position.
	ageInMs := anAnt ageInMs
]

{ #category : #'undo - undo' }
MAAntMementoExperimental >> undo [

	self restoreValues
]
