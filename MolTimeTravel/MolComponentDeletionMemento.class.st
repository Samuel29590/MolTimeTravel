Class {
	#name : #MolComponentDeletionMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentDeletionMemento >> redo [
	
	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass stop: componentReference componentName ]
]

{ #category : #actions }
MolComponentDeletionMemento >> save: aComponent [

	componentReference := MolComponentReference newFrom: aComponent.
]

{ #category : #'undo - undo' }
MolComponentDeletionMemento >> undo [
	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNil: [ componentReference componentClass start: componentReference componentName ]
]
