Class {
	#name : #MAComponentDeletionMementoExperimental,
	#superclass : #MAComponentMementoExperimental,
	#category : #MolAntsExperimental
}

{ #category : #'undo - undo' }
MAComponentDeletionMementoExperimental >> redo [ 
	
	self componentClass stop: self componentName.
	

]

{ #category : #actions }
MAComponentDeletionMementoExperimental >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName.
]

{ #category : #'undo - undo' }
MAComponentDeletionMementoExperimental >> undo [
	self componentClass start: self componentName
]
