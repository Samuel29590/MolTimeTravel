"
I'm the actual implementation of the queen role.
"
Class {
	#name : #MAQueen,
	#superclass : #MARole,
	#category : #MolAntsTimeTravel
}

{ #category : #'life cycle' }
MAQueen >> componentActivate [

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Subscription to the Time Travel event"
	self getTMATimeTravelEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAQueen >> componentInitialize [

	"Initialization of the MAQueen component."

	self forServices: TMASimulationServices useProvider: #default.
	
	roleName := #queen.

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Connection to the TimeTravel service."
	self forServices: TMATimeTravelServices useProvider: #default.
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component notifies its creation" 
			self getTMATimeTravelServicesProvider creationOf: self.
			"Component saves its state."
			self saveForTimeTravel ] ].
]

{ #category : #'life cycle' }
MAQueen >> componentPassivate [
	
	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Unsubscribe from the Time Travel event"
	self getTMATimeTravelEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAQueen >> componentRemove [

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		"Component saves its state."
		self saveForTimeTravel.
		"Component notifies its deletion"
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [ 
			self getTMATimeTravelServicesProvider deletionOf: self ] ].
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

		^ anAnt getPosition.

]

{ #category : #events }
MAQueen >> restoreFrom: aMemento [

	
]

{ #category : #role }
MAQueen >> saveForTimeTravel [

	| memento |
	memento := MAQueenMemento new.

	self getTMATimeTravelServicesProvider
		save: (memento save: self)
]
