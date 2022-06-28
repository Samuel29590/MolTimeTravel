Class {
	#name : #MAComponentStep,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'creationsAndDeletions'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentStep >> creationsAndDeletions [

	^ creationsAndDeletions
]

{ #category : #initialization }
MAComponentStep >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	creationsAndDeletions := OrderedCollection new
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
