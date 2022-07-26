Class {
	#name : #MolAntMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'ageInMs',
		'position',
		'stage'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolAntMemento >> getAgeInMs [

	^ ageInMs
]

{ #category : #accessing }
MolAntMemento >> getPosition [

	^ position
]

{ #category : #accessing }
MolAntMemento >> getStage [

	^ stage
]

{ #category : #'undo - undo' }
MolAntMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolAntMemento >> save: anAnt [

	componentReference := MolComponentReference newFrom: anAnt.

	position := anAnt getPosition.
	ageInMs := anAnt getAgeInMs.
	anAnt getStage ifNil:[stage:= nil] ifNotNil: [ 
	stage := (MolComponentReference newFrom: anAnt getStage) ].
]

{ #category : #'undo - undo' }
MolAntMemento >> undo [

	self restoreValues
]
