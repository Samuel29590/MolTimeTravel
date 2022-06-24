Class {
	#name : #MAComponentCreationMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAntsExperimental
}

{ #category : #testing }
MAComponentCreationMemento >> isCreation [

	^true.
]

{ #category : #'undo - undo' }
MAComponentCreationMemento >> redo [

	self componentClass start: self componentName.
]

{ #category : #'undo - undo' }
MAComponentCreationMemento >> undo [

	self componentClass stop: self componentName
]
