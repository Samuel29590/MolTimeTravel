Class {
	#name : #MAAntMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAntsExperimental
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

{ #category : #'undo - undo' }
MAAntMemento >> restoreValues [
]

{ #category : #actions }
MAAntMemento >> save: anAnt [

	componentName := anAnt componentName.
	position := anAnt position.
	ageInMs := anAnt ageInMs
]

{ #category : #'undo - undo' }
MAAntMemento >> undo [

	self restoreValues
]
