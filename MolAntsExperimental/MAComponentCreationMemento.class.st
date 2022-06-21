Class {
	#name : #MAComponentCreationMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'componentClass'
	],
	#category : #MolAntsExperimental
}

{ #category : #testing }
MAComponentCreationMemento >> componentClass [

	^ componentClass
]

{ #category : #testing }
MAComponentCreationMemento >> isCreation [

	^true.
]

{ #category : #testing }
MAComponentCreationMemento >> isRemoving [

	^ componentClass
]

{ #category : #actions }
MAComponentCreationMemento >> save: aComponent [

	componentName := aComponent componentName.
	componentClass := aComponent class
]
