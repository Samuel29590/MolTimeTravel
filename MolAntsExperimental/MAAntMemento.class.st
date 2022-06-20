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

{ #category : #actions }
MAAntMemento >> save: anAnt [

	componentName := anAnt componentName.
	position := anAnt position.
	ageInMs := anAnt ageInMs
]
