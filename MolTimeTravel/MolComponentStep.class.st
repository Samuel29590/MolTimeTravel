Class {
	#name : #MolComponentStep,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'creationsAndDeletions',
		'events'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolComponentStep >> creationsAndDeletions [

	^ creationsAndDeletions
]

{ #category : #accessing }
MolComponentStep >> events [

	^ events
]

{ #category : #initialization }
MolComponentStep >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	events := OrderedCollection new.
	creationsAndDeletions := OrderedCollection new
]

{ #category : #initialization }
MolComponentStep >> isANewStep [

	(mementos size > 0)|(creationsAndDeletions size > 0) ifTrue: [ ^ false ].
	
	^ true.
]

{ #category : #accessing }
MolComponentStep >> mementos [

	^ mementos
]

{ #category : #initialization }
MolComponentStep >> save: aComponentMemento [

	mementos add: aComponentMemento 
]

{ #category : #initialization }
MolComponentStep >> saveCreationOrDeletionOf: aComponentMemento [

	creationsAndDeletions add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveEvent: aComponentMemento [

	events add: aComponentMemento
]
