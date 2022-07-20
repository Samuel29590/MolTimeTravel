"
I'm the actual implementation of the fighter role.
"
Class {
	#name : #MAFighter,
	#superclass : #MARole,
	#category : #MolAntsTimeTravel
}

{ #category : #'life cycle' }
MAFighter >> componentActivate [

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Subscription to the Time Travel event"
	self getTMATimeTravelEventsSubscriber subscribe: self
]

{ #category : #role }
MAFighter >> componentInitialize [

	"Initialization of the MAFighter component."

	self forServices: TMASimulationServices useProvider: #default.
	
	roleName := #fighter.

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
MAFighter >> componentPassivate [
	
	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Unsubscribe from the Time Travel event"
	self getTMATimeTravelEventsSubscriber unsubscribe: self
]

{ #category : #role }
MAFighter >> componentRemove [

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
MAFighter >> doSimulationStepFor: anAnt [

	"For the moment fighter don't do nothing."

	| antRectangle |
	antRectangle := BlBounds
		                origin: anAnt getPosition - (6 @ 6)
		                extent: 12 @ 12.

	anAnt getInsects keysDo: [ :each | 
		| insectRectangle |
		insectRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: insectRectangle) ifTrue: [ 
			self getTMARoleEventsNotifier ant: anAnt killAt: each ] ]
]

{ #category : #role }
MAFighter >> moveFrom: anAnt [

	"A Fighter move randomly around the ant hill."

	| newPos antHillPos |
	newPos := anAnt getPosition + ((Random new next * 10 - 5) rounded
	           @ (Random new next * 10 - 5) rounded).
	antHillPos := MASimulationManager simulationAntHillPosition.

	newPos x < (antHillPos x - 50) ifTrue: [ 
		newPos := antHillPos x - 50 @ newPos y ].
	newPos y < (antHillPos y - 50) ifTrue: [ 
		newPos := newPos x @ (antHillPos y - 50) ].
	newPos x > (antHillPos x + 50) ifTrue: [ 
		newPos := antHillPos x + 50 @ newPos y ].
	newPos y > (antHillPos y + 50) ifTrue: [ 
		newPos := newPos x @ (antHillPos y + 50) ].

	^ newPos.

]

{ #category : #events }
MAFighter >> restoreFrom: aMemento [

	
]

{ #category : #events }
MAFighter >> saveForTimeTravel [

	| memento |
	memento := MAFighterMemento new.

	self getTMATimeTravelServicesProvider
		save: (memento save: self)
]
