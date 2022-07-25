Class {
	#name : #MolStageMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs',
		'stageName',
		'role'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolStageMemento >> getAdultStateDurationInMs [

	^ adultStateDurationInMs
]

{ #category : #accessing }
MolStageMemento >> getEggStateDurationInMs [

	^ eggStateDurationInMs
]

{ #category : #accessing }
MolStageMemento >> getRole [

	^ role
]

{ #category : #accessing }
MolStageMemento >> getStageName [ 

	^ stageName 
]

{ #category : #'undo - undo' }
MolStageMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolStageMemento >> save: aStage [

	componentClass := aStage class.
	componentName := aStage componentName.
	eggStateDurationInMs := aStage getEggStateDurationInMs.
	adultStateDurationInMs := aStage getAdultStateDurationInMs.
	stageName := aStage getStageName.
	
	aStage getRole ifNil:[role := nil] ifNotNil:[	role := aStage getRole class -> aStage getRole componentName]
	

]

{ #category : #'undo - undo' }
MolStageMemento >> undo [

	self restoreValues
]
