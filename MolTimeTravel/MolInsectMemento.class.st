Class {
	#name : #MolInsectMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'ageInMs',
		'position'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolInsectMemento >> getAgeInMs [

	^ ageInMs
]

{ #category : #accessing }
MolInsectMemento >> getPosition [

	^ position
]

{ #category : #accessing }
MolInsectMemento >> redo [ 

	self restoreValues.
]

{ #category : #actions }
MolInsectMemento >> save: anInsect [

	componentReference := MolComponentReference newFrom: anInsect.
	
	position := anInsect getPosition.
	ageInMs := anInsect getAgeInMs
]

{ #category : #accessing }
MolInsectMemento >> undo [

	self restoreValues
]
