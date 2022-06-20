Class {
	#name : #MAInsectMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'position',
		'ageInMs'
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

{ #category : #actions }
MAInsectMemento >> save: anInsect [

	
	componentName := anInsect componentName.
	position := anInsect position.
	ageInMs := anInsect ageInMs
]
