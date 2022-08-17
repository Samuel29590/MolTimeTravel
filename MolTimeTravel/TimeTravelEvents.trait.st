Trait {
	#name : #TimeTravelEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #MolTimeTravel
}

{ #category : #events }
TimeTravelEvents >> restoreFrom: aMemento [

	| variablesTemp |
	
	variablesTemp := aMemento getReproducedVariables.
	
	variablesTemp do: [ :var | self instVarNamed: (var key) put: (var value) ].
]

{ #category : #events }
TimeTravelEvents >> saveForTimeTravel [

	| memento |
	memento := MolGeneralMemento new.

	self getTimeTravelServicesProvider
		save: (memento save: self)
]

{ #category : #events }
TimeTravelEvents >> startTimeTravel [

	
]

{ #category : #events }
TimeTravelEvents >> stopTimeTravel [

	
]
