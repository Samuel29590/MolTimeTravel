Class {
	#name : #MAInsectMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ageInMs',
		'position'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAInsectMemento >> ageInMs [

	^ ageInMs
]

{ #category : #accessing }
MAInsectMemento >> position [

	^ position
]

{ #category : #accessing }
MAInsectMemento >> redo [ 

	self restoreValues.
]

{ #category : #actions }
MAInsectMemento >> save: anInsect [

	componentClass := anInsect class.
	componentName := anInsect componentName.
	position := anInsect position.
	ageInMs := anInsect ageInMs
]

{ #category : #accessing }
MAInsectMemento >> undo [

	self restoreValues
]
