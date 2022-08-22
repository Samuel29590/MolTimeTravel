Class {
	#name : #MolComponentActivateMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentActivateMemento >> redo [

	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass activateFromTimeTravel: componentReference componentName ]
]

{ #category : #'undo - undo' }
MolComponentActivateMemento >> save: aComponent [

	componentReference := MolComponentReference newFrom: aComponent.
]

{ #category : #'undo - undo' }
MolComponentActivateMemento >> undo [

		(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass passivateFromTimeTravel: componentReference componentName ]
]
