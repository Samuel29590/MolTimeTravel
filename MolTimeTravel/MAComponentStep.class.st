Class {
	#name : #MAComponentStep,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'creationsAndDeletions',
		'events'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MAComponentStep >> creationsAndDeletions [

	^ creationsAndDeletions
]

{ #category : #accessing }
MAComponentStep >> events [

	^ events
]

{ #category : #initialization }
MAComponentStep >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	events := OrderedCollection new.
	creationsAndDeletions := OrderedCollection new
]

{ #category : #initialization }
MAComponentStep >> isANewStep [

	(mementos size > 0)|(creationsAndDeletions size > 0) ifTrue: [ ^ false ].
	
	^ true.
]

{ #category : #accessing }
MAComponentStep >> mementos [

	^ mementos
]

{ #category : #initialization }
MAComponentStep >> save: aComponentMemento [

	mementos add: aComponentMemento 
]

{ #category : #initialization }
MAComponentStep >> saveCreationOrDeletionOf: aComponentMemento [

	creationsAndDeletions add: aComponentMemento
]

{ #category : #initialization }
MAComponentStep >> saveEvent: aComponentMemento [

	events add: aComponentMemento
]
