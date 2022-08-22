Class {
	#name : #MolComponentDeletionMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentDeletionMemento >> redo [
	
	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass stopFromTimeTravel: componentReference componentName ]
]

{ #category : #actions }
MolComponentDeletionMemento >> save: aComponent [

	componentReference := MolComponentReference newFrom: aComponent.
]

{ #category : #'undo - undo' }
MolComponentDeletionMemento >> undo [
	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNil: [ componentReference componentClass startFromTimeTravel: componentReference componentName ]
]
