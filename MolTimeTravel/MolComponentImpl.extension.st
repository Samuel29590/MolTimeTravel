Extension { #name : #MolComponentImpl }

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> activate [

	"--------------------------Time Travel--------------------------"
	| timetravel |
	timetravel := MolUtils instanceOf: MolTimeTravel named: #default.
	timetravel ifNotNil: [ timetravel isRestoring ifTrue: [ ^ nil ] ].
	"---------------------------------------------------------------"

	^ MolComponentManager default homeServices activateComponentWithTimeTravelSave: self
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> activate: aComponentName [

	"--------------------------Time Travel--------------------------"
	| timetravel |
	timetravel := MolUtils instanceOf: MolTimeTravel named: #default.
	timetravel ifNotNil: [ timetravel isRestoring ifTrue: [ ^ nil ] ].
	"---------------------------------------------------------------"

	^ MolComponentManager default homeServices activateComponentWithTimeTravelSave: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> activateFromTimeTravel: aComponentName [

	^ MolComponentManager default homeServices activateComponentWithTimeTravelSave: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl >> isUsingTimeTravel [

	^ false.
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> passivate [

	"--------------------------Time Travel--------------------------"
	| timetravel |
	timetravel := MolUtils instanceOf: MolTimeTravel named: #default.
	timetravel ifNotNil: [ timetravel isRestoring ifTrue: [ ^ nil ] ].
	"---------------------------------------------------------------"
	
	^ MolComponentManager default homeServices passivateComponentWithTimeTravelSave: self
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> passivate: aComponentName [

	"--------------------------Time Travel--------------------------"
	| timetravel |
	timetravel := MolUtils instanceOf: MolTimeTravel named: #default.
	timetravel ifNotNil: [ timetravel isRestoring ifTrue: [ ^ nil ] ].
	"---------------------------------------------------------------"
	
	^ MolComponentManager default homeServices passivateComponentWithTimeTravelSave: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> passivateFromTimeTravel: aComponentName [

	^ MolComponentManager default homeServices passivateComponentWithTimeTravelSave: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> start: aComponentName [

	"--------------------------Time Travel--------------------------"
	| timetravel |
	timetravel := MolUtils instanceOf: MolTimeTravel named: #default.
	timetravel ifNotNil: [ timetravel isRestoring ifTrue: [ ^ nil ] ].
	"---------------------------------------------------------------"

	^ MolUtils startComponent: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> startFromTimeTravel: aComponentName [

	^ MolUtils startComponent: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> stop: aComponentName [

	"--------------------------Time Travel--------------------------"
	| timetravel |
	timetravel := MolUtils instanceOf: MolTimeTravel named: #default.
	timetravel ifNotNil: [ timetravel isRestoring ifTrue: [ ^ nil ] ].
	"---------------------------------------------------------------"
	
	^ MolUtils stopComponent: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl classSide >> stopFromTimeTravel: aComponentName [

	^ MolUtils stopComponent: self named: aComponentName
]

{ #category : #'*MolTimeTravel' }
MolComponentImpl >> timeTravelEncoder [

	"Encode Component in order to get MolComponentReference instead of a component reference."

	^ MolComponentReference newFrom: self
]
