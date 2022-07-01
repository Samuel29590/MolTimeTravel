Class {
	#name : #MAInsectMementoExperimental,
	#superclass : #MAComponentMementoExperimental,
	#instVars : [
		'ageInMs',
		'position'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAInsectMementoExperimental >> ageInMs [

	^ ageInMs
]

{ #category : #accessing }
MAInsectMementoExperimental >> position [

	^ position
]

{ #category : #accessing }
MAInsectMementoExperimental >> redo [ 

	self restoreValues.
]

{ #category : #actions }
MAInsectMementoExperimental >> save: anInsect [

	componentClass := anInsect class.
	componentName := anInsect componentName.
	position := anInsect position.
	ageInMs := anInsect ageInMs
]

{ #category : #accessing }
MAInsectMementoExperimental >> undo [

	self restoreValues
]
