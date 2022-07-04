"
I'm the actual implementation of the queen role.
"
Class {
	#name : #MAQueen,
	#superclass : #MARole,
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAQueen >> componentActivate [

	self getTMATimeTravelEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAQueen >> componentInitialize [

	"Initialization of the MAQueen component."

	roleName := #queen.

	self forServices: TMATimeTravelServices useProvider: #TimeTravel.

	self forServices: TMASimulationServices useProvider: #default.

	self getTMATimeTravelServicesProvider isRestoring ifFalse: [ "queen notify the creation"
		self getTMATimeTravelServicesProvider
			creationOf: self
			at: self getTMASimulationServicesProvider step ]
]

{ #category : #'life cycle' }
MAQueen >> componentPassivate [

	self getTMATimeTravelEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAQueen >> componentRemove [

	"Queen notify its remove"

	(MolUtils instanceOf: MATimeTravel named: #TimeTravel) ifNotNil: [ self getTMATimeTravelServicesProvider isRestoring ifFalse: [ 
		self getTMATimeTravelServicesProvider
			removeOf: self
			at: self getTMASimulationServicesProvider step ]]

	
]

{ #category : #role }
MAQueen >> doSimulationStepFor: anAnt [

	"A queen as 25% of chance to laid at each step."

	(Random new nextIntegerBetween: 1 and: 4) = 1 ifTrue: [ 
		self getTMARoleEventsNotifier queenLaid ]
]

{ #category : #role }
MAQueen >> moveFrom: anAnt [

	"A queen don't move."

	^ anAnt position
]

{ #category : #events }
MAQueen >> restoreFrom: aMemento [

	
]
