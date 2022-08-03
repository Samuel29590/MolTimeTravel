Class {
	#name : #MolComponentServiceMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'serviceName',
		'parameters',
		'needToReplay'
	],
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentServiceMemento >> redo [

	| realParameters |
	needToReplay ifTrue: [ 
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
			perform: serviceName
			withArguments: realParameters ]
]

{ #category : #'undo - undo' }
MolComponentServiceMemento >> saveService: aMethodName performBy: aComponent withParameters: someParameters needToReplay: aBoolean [

	componentReference := MolComponentReference newFrom: aComponent.

	serviceName := aMethodName.

	parameters := OrderedCollection new.
	
	needToReplay := aBoolean.
	
	someParameters do: [ :parameter | 
		parameter isComponent
			ifTrue: [ 
			parameters add: (MolComponentReference newFrom: parameter) ]
			ifFalse: [ parameters add: parameter ] ]
]

{ #category : #'undo - undo' }
MolComponentServiceMemento >> undo [

	| realParameters |
	needToReplay ifTrue: [ 
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
			perform: serviceName
			withArguments: realParameters ]
]
