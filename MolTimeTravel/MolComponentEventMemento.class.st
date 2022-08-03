Class {
	#name : #MolComponentEventMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'eventName',
		'parameters',
		'needToReplay'
	],
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentEventMemento >> redo [

	| realParameters |
	
	needToReplay ifTrue:[
	realParameters := OrderedCollection new.

	parameters do: [ :parameter | 
		parameter isAssociation
			ifTrue: [ 
				realParameters add:
					(MolUtils instanceOf: parameter key named: parameter value) ]
			ifFalse: [ realParameters add: parameter ] ].
	realParameters := realParameters asArray.

	(MolUtils
		 instanceOf: componentReference componentClass
		 named: componentReference componentName)
		perform: eventName
		withArguments: realParameters]
]

{ #category : #'undo - undo' }
MolComponentEventMemento >> saveEvent: aMethodName performBy: aComponent withParameters: someParameters needToReplay: aBoolean [

	componentReference := MolComponentReference newFrom: aComponent.

	eventName := aMethodName.

	parameters := OrderedCollection new.
	
	needToReplay := aBoolean.
	
	someParameters do: [ :parameter | 
		parameter isComponent
			ifTrue: [ 
			parameters add: (MolComponentReference newFrom: parameter) ]
			ifFalse: [ parameters add: parameter ] ]
]

{ #category : #'undo - undo' }
MolComponentEventMemento >> undo [

	| realParameters |
	needToReplay ifTrue:[
	realParameters := OrderedCollection new.

	parameters do: [ :parameter | 
		parameter isAssociation
			ifTrue: [ 
				realParameters add:
					(MolUtils instanceOf: parameter key named: parameter value) ]
			ifFalse: [ realParameters add: parameter ] ].
	realParameters := realParameters asArray.

	(MolUtils
		 instanceOf: componentReference componentClass
		 named: componentReference componentName)
		perform: eventName
		withArguments: realParameters]
]
