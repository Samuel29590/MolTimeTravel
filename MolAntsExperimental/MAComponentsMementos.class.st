Class {
	#name : #MAComponentsMementos,
	#superclass : #Object,
	#instVars : [
		'mementos'
	],
	#category : #MolAntsExperimental
}

{ #category : #initialization }
MAComponentsMementos >> initialize [

	super initialize.
	mementos := OrderedCollection new
]

{ #category : #accessing }
MAComponentsMementos >> mementos [

	^ mementos
]

{ #category : #initialization }
MAComponentsMementos >> save: aComponentMemento [

	mementos add: aComponentMemento 
]
