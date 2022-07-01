Class {
	#name : #MAComponentCreationMementoExperimental,
	#superclass : #MAComponentMementoExperimental,
	#category : #MolAntsExperimental
}

{ #category : #'undo - undo' }
MAComponentCreationMementoExperimental >> redo [

	self componentClass start: self componentName.
]

{ #category : #'undo - undo' }
MAComponentCreationMementoExperimental >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MAComponentCreationMementoExperimental >> undo [

	self componentClass stop: self componentName
]
