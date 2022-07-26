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

	componentReference := MolComponentReference newFrom: aStage.
	
	eggStateDurationInMs := aStage getEggStateDurationInMs.
	adultStateDurationInMs := aStage getAdultStateDurationInMs.
	stageName := aStage getStageName.
	
	aStage getRole ifNil:[role := nil] ifNotNil:[	role := (MolComponentReference newFrom: aStage getRole) ]
	

]

{ #category : #'undo - undo' }
MolStageMemento >> undo [

	self restoreValues
]
