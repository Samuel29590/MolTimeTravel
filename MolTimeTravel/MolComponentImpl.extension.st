Extension { #name : #MolComponentImpl }

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> activate [

	^ MolComponentManager default homeServices activateComponentWithTimeTravelSave: self
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> activate: aComponentName [

	^ MolComponentManager default homeServices activateComponentWithTimeTravelSave: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl >> isUsingTimeTravel [

	^ false.
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> passivate [

	^ MolComponentManager default homeServices passivateComponentWithTimeTravelSave: self
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> passivate: aComponentName [

	^ MolComponentManager default homeServices passivateComponentWithTimeTravelSave: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl >> timeTravelEncoder [

	"Encode Component in order to get MolComponentReference instead of a component reference."

	^ MolComponentReference newFrom: self
]
