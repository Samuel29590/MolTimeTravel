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

	"--------------------------Time Travel--------------------------"
	"Subscription to the Time Travel event"
	self getTimeTravelEventsSubscriber subscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAQueen >> componentInitialize [
	
	"Initialization of the MAQueen component."

	self forServices: TMASimulationServices useProvider: #default.
	
	roleName := #queen.
]

{ #category : #'life cycle' }
MAQueen >> componentPassivate [
	
	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTimeTravelEventsSubscriber unsubscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #role }
MAQueen >> doSimulationStepFor: anAnt [

	"A queen as 25% of chance to laid at each step."

	(Random new nextIntegerBetween: 1 and: 4) = 1 ifTrue: [ 
		self getTMARoleEventsNotifier queenLaid ]
]

{ #category : #testing }
MAQueen >> isUsingTimeTravel [

	^ true.
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
	memento := MolQueenMemento new.

	self getTimeTravelServicesProvider
		save: (memento save: self)
]
