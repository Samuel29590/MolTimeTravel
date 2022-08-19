Extension { #name : #Object }

{ #category : #'*MolTimeTravel' }
Object >> isComponentReference [
	^ false
]

{ #category : #'*MolTimeTravel' }
Object >> isProcess [

	^ false
]

{ #category : #'*MolTimeTravel' }
Object >> timeTravelDecoder [

	"Decode Object in order to get a component reference instead of a MolComponentReference."

	^ self
]

{ #category : #'*MolTimeTravel' }
Object >> timeTravelEncoder [

	"Encode Object in order to get MolComponentReference instead of a component reference."
	
	^ self
]
