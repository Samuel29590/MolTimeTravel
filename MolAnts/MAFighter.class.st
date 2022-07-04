"
I'm the actual implementation of the fighter role.
"
Class {
	#name : #MAFighter,
	#superclass : #MARole,
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAFighter >> componentActivate [

	self getTMATimeTravelEventsSubscriber subscribe: self
]

{ #category : #role }
MAFighter >> componentInitialize [

	"Initialization of the MAFighter component."

	roleName := #fighter.

	self forServices: TMATimeTravelServices useProvider: #TimeTravel.

	self forServices: TMASimulationServices useProvider: #default.

	self getTMATimeTravelServicesProvider isRestoring ifFalse: [ "fighter notify the creation"
		self getTMATimeTravelServicesProvider
			creationOf: self
			at: self getTMASimulationServicesProvider getStep ]
]

{ #category : #'life cycle' }
MAFighter >> componentPassivate [

	self getTMATimeTravelEventsSubscriber unsubscribe: self
]

{ #category : #role }
MAFighter >> componentRemove [

	"Fighter notify its remove"

	(MolUtils instanceOf: MATimeTravel named: #TimeTravel) ifNotNil: [ self getTMATimeTravelServicesProvider isRestoring 
		ifFalse: [ 
			self getTMATimeTravelServicesProvider
				removeOf: self
				at: self getTMASimulationServicesProvider getStep ]].

	
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

	^ newPos
]

{ #category : #events }
MAFighter >> restoreFrom: aMemento [

	
]
