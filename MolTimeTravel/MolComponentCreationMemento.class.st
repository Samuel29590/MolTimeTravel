Class {
	#name : #MolComponentCreationMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentCreationMemento >> redo [

	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNil: [ componentReference componentClass startFromTimeTravel: componentReference componentName ]
]

{ #category : #'undo - undo' }
MolComponentCreationMemento >> save: aComponent [

	componentReference := MolComponentReference newFrom: aComponent.
]

{ #category : #'undo - undo' }
MolComponentCreationMemento >> undo [

		(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass stopFromTimeTravel: componentReference componentName ]
]
