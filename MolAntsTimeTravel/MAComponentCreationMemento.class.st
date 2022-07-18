Class {
	#name : #MAComponentCreationMemento,
	#superclass : #MAComponentMemento,
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MAComponentCreationMemento >> redo [

	(MolUtils
		 instanceOf: self componentClass
		 named: self componentName) ifNil: [ 
		self componentClass start: self componentName ]
]

{ #category : #'undo - undo' }
MAComponentCreationMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MAComponentCreationMemento >> undo [

		(MolUtils instanceOf: self componentClass named: self componentName) 
		ifNotNil: [ self componentClass stop: self componentName ]
]
