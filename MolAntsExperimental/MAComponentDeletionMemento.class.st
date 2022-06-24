Class {
	#name : #MAComponentDeletionMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAntsExperimental
}

{ #category : #actions }
MAComponentDeletionMemento >> isDeletion [
	^ true
]

{ #category : #'undo - undo' }
MAComponentDeletionMemento >> redo [ 
	
	self componentClass stop: self componentName.
	

]

{ #category : #'undo - undo' }
MAComponentDeletionMemento >> undo [
	self componentClass start: self componentName
]
