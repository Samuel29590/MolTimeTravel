Class {
	#name : #MAComponentStepExperimental,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'creationsAndDeletions'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentStepExperimental >> creationsAndDeletions [

	^ creationsAndDeletions
]

{ #category : #initialization }
MAComponentStepExperimental >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	creationsAndDeletions := OrderedCollection new
]

{ #category : #accessing }
MAComponentStepExperimental >> mementos [

	^ mementos
]

{ #category : #initialization }
MAComponentStepExperimental >> save: aComponentMemento [

	mementos add: aComponentMemento 
]

{ #category : #initialization }
MAComponentStepExperimental >> saveCreationOrDeletionOf: aComponentMemento [

	creationsAndDeletions add: aComponentMemento
]
