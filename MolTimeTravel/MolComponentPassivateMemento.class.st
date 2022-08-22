Class {
	#name : #MolComponentPassivateMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentPassivateMemento >> redo [

	(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass passivateFromTimeTravel: componentReference componentName ]
]

{ #category : #'undo - undo' }
MolComponentPassivateMemento >> save: aComponent [

	componentReference := MolComponentReference newFrom: aComponent.
]

{ #category : #'undo - undo' }
MolComponentPassivateMemento >> undo [

		(MolUtils instanceOf: componentReference componentClass named: componentReference componentName) 
		ifNotNil: [ componentReference componentClass activateFromTimeTravel: componentReference componentName ]
]
