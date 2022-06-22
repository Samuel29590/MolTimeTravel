Class {
	#name : #MAComponentLifeCycleMemento,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentLifeCycleMemento >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MAComponentLifeCycleMemento >> componentName [

	^ componentName
]

{ #category : #testing }
MAComponentLifeCycleMemento >> isCreation [

	^ false
]

{ #category : #testing }
MAComponentLifeCycleMemento >> isDeletion [

	^ false
]

{ #category : #actions }
MAComponentLifeCycleMemento >> save: aComponent [

	componentName := aComponent componentName.
	componentClass := aComponent class
]
