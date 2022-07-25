Class {
	#name : #MolComponentEventMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'eventName',
		'parameters'
	],
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentEventMemento >> redo [

	|realParameters|

	realParameters := OrderedCollection new.

	parameters do: [ :parameter |
		parameter isAssociation ifTrue:[ realParameters add: (MolUtils instanceOf: parameter key named: parameter value) ]
		ifFalse:[ realParameters add: parameter ]
	].
	realParameters := realParameters asArray.

	(MolUtils instanceOf: self componentClass named: self componentName)
		perform: eventName
		withArguments: realParameters
]

{ #category : #'undo - undo' }
MolComponentEventMemento >> save: aComponent [

	componentClass := aComponent class.
	componentName := aComponent componentName
]

{ #category : #'undo - undo' }
MolComponentEventMemento >> saveEvent: aMethodName performBy: aComponent withParameters: someParameters [

	componentClass := aComponent class.
	componentName := aComponent componentName.
	eventName := aMethodName.
	
	parameters := OrderedCollection new.
	
	someParameters do: [ :parameter |
			parameter isComponent ifTrue: [ parameters add: (parameter class -> parameter componentName) ]
			ifFalse: [ parameters add: parameter ]
		 ].
	
]

{ #category : #'undo - undo' }
MolComponentEventMemento >> undo [


]
