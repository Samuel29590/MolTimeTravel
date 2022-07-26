Class {
	#name : #MolComponentReference,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolTimeTravel
}

{ #category : #'instance creation' }
MolComponentReference class >> newFrom: aComponent [

	| myComponentReference |
	
	myComponentReference := self new.
	myComponentReference componentClass: aComponent class.
	myComponentReference componentName: aComponent componentName.
	
	^myComponentReference 
]

{ #category : #accessing }
MolComponentReference >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MolComponentReference >> componentClass: anObject [

	componentClass := anObject
]

{ #category : #accessing }
MolComponentReference >> componentName [

	^ componentName
]

{ #category : #accessing }
MolComponentReference >> componentName: anObject [

	componentName := anObject
]

{ #category : #testing }
MolComponentReference >> isComponentReference [
	^ true
]
