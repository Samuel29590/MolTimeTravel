Class {
	#name : #MAAntMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ageInMs',
		'position'
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
	ageInMs := anAnt ageInMs
]

{ #category : #'undo - undo' }
MAAntMemento >> undo [

	self restoreValues
]
