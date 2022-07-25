Class {
	#name : #MolComponentCreationMemento,
	#superclass : #MolComponentMemento,
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentCreationMemento >> redo [

	(MolUtils
		 instanceOf: self componentClass
		 named: self componentName) ifNil: [ 
		self componentClass start: self componentName ]
]

{ #category : #'undo - undo' }
MolComponentCreationMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MolComponentCreationMemento >> undo [

		(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNotNil: [ self componentClass stop: self componentName ]
]
