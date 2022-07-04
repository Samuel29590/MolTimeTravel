Class {
	#name : #MAInsectMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ageInMs',
		'position'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAInsectMemento >> getAgeInMs [

	^ ageInMs
]

{ #category : #accessing }
MAInsectMemento >> getPosition [

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
	position := anInsect getPosition.
	ageInMs := anInsect getAgeInMs
]

{ #category : #accessing }
MAInsectMemento >> undo [

	self restoreValues
]
