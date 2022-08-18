Extension { #name : #Association }

{ #category : #'*MolTimeTravel' }
Association >> timeTravelDecoder [

	"Decode Association in order to get a component reference instead of a MolComponentReference."

	^ self key timeTravelDecoder -> self value timeTravelDecoder
]

{ #category : #'*MolTimeTravel' }
Association >> timeTravelEncoder [

	"Encode Association in order to get MolComponentReference instead of a component reference."

	^ self key timeTravelEncoder -> self value timeTravelEncoder
]
