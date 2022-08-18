Extension { #name : #SmallDictionary }

{ #category : #'*MolTimeTravel' }
SmallDictionary >> timeTravelDecoder [

	"Decode SmallDict in order to get a component reference instead of a MolComponentReference."

	| variableTemp |
	variableTemp := self class new.
	self associationsDo: [ :assoc | 
		variableTemp add: assoc timeTravelDecoder ].
	^ variableTemp
]

{ #category : #'*MolTimeTravel' }
SmallDictionary >> timeTravelEncoder [

	"Encode SmallDict in order to get MolComponentReference instead of a component reference."

	| variableTemp |
	variableTemp := self class new.
	self associationsDo: [ :assoc | 
		variableTemp add: assoc timeTravelEncoder ].
	^ variableTemp
]
