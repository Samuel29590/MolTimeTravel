Class {
	#name : #MAComponentsMementos,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'componentsLifeCycles'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentsMementos >> componentsLifeCycles [

	^ componentsLifeCycles
]

{ #category : #initialization }
MAComponentsMementos >> initialize [

	super initialize.
	mementos := OrderedCollection new.
	componentsLifeCycles := OrderedCollection new
]

{ #category : #accessing }
MAComponentsMementos >> mementos [

	^ mementos
]

{ #category : #initialization }
MAComponentsMementos >> save: aComponentMemento [

	mementos add: aComponentMemento 
]

{ #category : #initialization }
MAComponentsMementos >> saveCreationOf: aComponentMemento [

	componentsLifeCycles add: aComponentMemento
]

{ #category : #initialization }
MAComponentsMementos >> saveRemoveOf: aComponentMemento [

	componentsLifeCycles add: aComponentMemento
]
