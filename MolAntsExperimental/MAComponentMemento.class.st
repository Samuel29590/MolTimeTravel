Class {
	#name : #MAComponentMemento,
	#superclass : #Object,
	#instVars : [
		'componentName'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentMemento >> componentName [

	^ componentName
]

{ #category : #testing }
MAComponentMemento >> isMemento [

	^true
]

{ #category : #actions }
MAComponentMemento >> save: aComponent [
]
