Extension { #name : #Bag }

{ #category : #'*MolTimeTravel' }
Bag >> timeTravelDecoder [

	"Decode Bag in order to get a component reference instead of a MolComponentReference."

	| variableTemp |
	variableTemp := self class new.
	self associationsDo: [ :assoc | 
		variableTemp add: assoc timeTravelDecoder ].
	^ variableTemp
]

{ #category : #'*MolTimeTravel' }
Bag >> timeTravelEncoder [

	"Encode Bag in order to get MolComponentReference instead of a component reference."

	| variableTemp |
	variableTemp := self class new.
	self associationsDo: [ :assoc | 
		variableTemp add: assoc timeTravelEncoder ].
	^ variableTemp
]
