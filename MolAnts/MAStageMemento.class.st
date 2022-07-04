Class {
	#name : #MAStageMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs',
		'stageName',
		'role'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAStageMemento >> adultStateDurationInMs [

	^ adultStateDurationInMs
]

{ #category : #accessing }
MAStageMemento >> eggStateDurationInMs [

	^ eggStateDurationInMs
]

{ #category : #'undo - undo' }
MAStageMemento >> redo [

	self restoreValues.
]

{ #category : #accessing }
MAStageMemento >> role [

	^ role
]

{ #category : #actions }
MAStageMemento >> save: aStage [

	componentClass := aStage class.
	componentName := aStage componentName.
	eggStateDurationInMs := aStage eggStateDurationInMs.
	adultStateDurationInMs := aStage adultStateDurationInMs.
	stageName := aStage stageName.
	role := aStage getRole class -> aStage getRole componentName
]

{ #category : #accessing }
MAStageMemento >> stageName [ 

	^ stageName 
]

{ #category : #'undo - undo' }
MAStageMemento >> undo [

	self restoreValues
]
