Extension { #name : #OrderedDictionary }

{ #category : #'*MolTimeTravel' }
OrderedDictionary >> timeTravelDecoder [

	"Decode OrderedDictionnary in order to get a component reference instead of a MolComponentReference."

	| variableTemp |
	variableTemp := self class new.
	self associationsDo: [ :assoc | 
		variableTemp add: assoc timeTravelDecoder ].
	^ variableTemp
]

{ #category : #'*MolTimeTravel' }
OrderedDictionary >> timeTravelEncoder [

	"Encode OrderedDictionnary in order to get MolComponentReference instead of a component reference."

	| variableTemp |
	variableTemp := self class new.
	self associationsDo: [ :assoc | 
		variableTemp add: assoc timeTravelEncoder ].
	^ variableTemp
]
