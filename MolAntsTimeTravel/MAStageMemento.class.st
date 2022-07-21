Class {
	#name : #MAStageMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs',
		'stageName',
		'role'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #accessing }
MAStageMemento >> getAdultStateDurationInMs [

	^ adultStateDurationInMs
]

{ #category : #accessing }
MAStageMemento >> getEggStateDurationInMs [

	^ eggStateDurationInMs
]

{ #category : #accessing }
MAStageMemento >> getRole [

	^ role
]

{ #category : #accessing }
MAStageMemento >> getStageName [ 

	^ stageName 
]

{ #category : #'undo - undo' }
MAStageMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAStageMemento >> save: aStage [

	componentClass := aStage class.
	componentName := aStage componentName.
	eggStateDurationInMs := aStage getEggStateDurationInMs.
	adultStateDurationInMs := aStage getAdultStateDurationInMs.
	stageName := aStage getStageName.
	
	aStage getRole ifNil:[role := nil] ifNotNil:[	role := aStage getRole class -> aStage getRole componentName]
	

]

{ #category : #'undo - undo' }
MAStageMemento >> undo [

	self restoreValues
]
