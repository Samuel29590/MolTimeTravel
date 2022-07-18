Class {
	#name : #MAComponentDeletionMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MAComponentDeletionMemento >> redo [
	
	(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNotNil: [ self componentClass stop: self componentName ]
]

{ #category : #actions }
MAComponentDeletionMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName.
]

{ #category : #'undo - undo' }
MAComponentDeletionMemento >> undo [
	(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNil: [ self componentClass start: self componentName ]
]
