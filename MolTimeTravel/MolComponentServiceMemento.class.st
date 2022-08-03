Class {
	#name : #MolComponentServiceMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'parameters',
		'serviceName'
	],
	#category : #MolTimeTravel
}

{ #category : #'undo - undo' }
MolComponentServiceMemento >> redo [

]

{ #category : #'undo - undo' }
MolComponentServiceMemento >> saveService: aMethodName performBy: aComponent withParameters: someParameters [

	componentReference := MolComponentReference newFrom: aComponent.
	
	serviceName := aMethodName.

	parameters := OrderedCollection new.
	
	someParameters do: [ :parameter |
			parameter isComponent ifTrue: [ parameters add: (MolComponentReference newFrom: parameter ) ]
			ifFalse: [ parameters add: parameter ]
		 ].
	
]

{ #category : #'undo - undo' }
MolComponentServiceMemento >> undo [

]
