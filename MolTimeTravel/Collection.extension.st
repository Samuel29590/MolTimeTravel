Extension { #name : #Collection }

{ #category : #'*MolTimeTravel' }
Collection >> timeTravelDecoder [

	"Decode Collection in order to get a component reference instead of a MolComponentReference."

	^ self collect: [ :each | each timeTravelDecoder ]
]

{ #category : #'*MolTimeTravel' }
Collection >> timeTravelEncoder [

	"Encode Collection in order to get MolComponentReference instead of a component reference."

	^ self collect: [ :each | each timeTravelEncoder ].
]
