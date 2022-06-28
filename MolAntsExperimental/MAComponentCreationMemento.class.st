Class {
	#name : #MAComponentCreationMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAntsExperimental
}

{ #category : #'undo - undo' }
MAComponentCreationMemento >> redo [

	self componentClass start: self componentName.
]

{ #category : #'undo - undo' }
MAComponentCreationMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MAComponentCreationMemento >> undo [

	self componentClass stop: self componentName
]
