Class {
	#name : #MAStageMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs'
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

{ #category : #actions }
MAStageMemento >> save: aStage [

	componentClass := aStage class.
	componentName := aStage componentName.
	eggStateDurationInMs := aStage eggStateDurationInMs.
	adultStateDurationInMs := aStage adultStateDurationInMs
]

{ #category : #'undo - undo' }
MAStageMemento >> undo [

	self restoreValues
]
