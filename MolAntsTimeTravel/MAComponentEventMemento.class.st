Class {
	#name : #MAComponentEventMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'eventName',
		'parameters'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #'undo - undo' }
MAComponentEventMemento >> redo [

	(MolUtils instanceOf: self componentClass named: self componentName)
		perform: eventName
		withArguments: parameters
]

{ #category : #'undo - undo' }
MAComponentEventMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MAComponentEventMemento >> saveEvent: aMethodName performBy: aComponent withParameters: someParameters [

	componentClass := aComponent class.
	componentName := aComponent componentName.
	eventName := aMethodName.
	parameters := someParameters.
]

{ #category : #'undo - undo' }
MAComponentEventMemento >> undo [


]
