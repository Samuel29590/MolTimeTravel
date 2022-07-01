Class {
	#name : #MAComponentDeletionMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAnts
}

{ #category : #'undo - undo' }
MAComponentDeletionMemento >> redo [ 
	
	self componentClass stop: self componentName.
	

]

{ #category : #actions }
MAComponentDeletionMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName.
]

{ #category : #'undo - undo' }
MAComponentDeletionMemento >> undo [
	self componentClass start: self componentName
]
