Class {
	#name : #MAComponentMemento,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentMemento >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MAComponentMemento >> componentName [

	^ componentName
]

{ #category : #'undo - undo' }
MAComponentMemento >> redo [
]

{ #category : #actions }
MAComponentMemento >> save: aComponent [
]

{ #category : #'undo - undo' }
MAComponentMemento >> undo [

	
]
