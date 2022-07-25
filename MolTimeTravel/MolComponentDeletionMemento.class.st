Class {
	#name : #MolComponentDeletionMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentDeletionMemento >> redo [
	
	(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNotNil: [ self componentClass stop: self componentName ]
]

{ #category : #actions }
MolComponentDeletionMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName.
]

{ #category : #'undo - undo' }
MolComponentDeletionMemento >> undo [
	(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNil: [ self componentClass start: self componentName ]
]
