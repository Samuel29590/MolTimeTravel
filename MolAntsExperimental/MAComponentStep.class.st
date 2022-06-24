Class {
	#name : #MAComponentStep,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'componentsLifeCycles'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentStep >> componentsLifeCycles [

	^ componentsLifeCycles
]

{ #category : #initialization }
MAComponentStep >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	componentsLifeCycles := OrderedCollection new
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
MAComponentStep >> saveCreationOf: aComponentMemento [

	componentsLifeCycles add: aComponentMemento
]

{ #category : #initialization }
MAComponentStep >> saveRemoveOf: aComponentMemento [

	componentsLifeCycles add: aComponentMemento
]
