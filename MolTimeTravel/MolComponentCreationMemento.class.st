Class {
	#name : #MolComponentCreationMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentCreationMemento >> redo [

	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNil: [ componentReference componentClass start: componentReference componentName ]
]

{ #category : #'undo - undo' }
MolComponentCreationMemento >> save: aComponent [

	componentReference := MolComponentReference newFrom: aComponent.
]

{ #category : #'undo - undo' }
MolComponentCreationMemento >> undo [

		(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass stop: componentReference componentName ]
]
