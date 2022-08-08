"
I'm the actual implementation of the fighter role.
"
Class {
	#name : #MAFighter,
	#superclass : #MARole,
	#category : #MolAntsTimeTravel
}

{ #category : #role }
MAFighter >> componentInitialize [
	
	"Initialization of the MAFighter component."

	self forServices: TMASimulationServices useProvider: #default.
	
	roleName := #fighter.
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

{ #category : #events }
MAFighter >> isUsingTimeTravel [

	^ true.
]

{ #category : #role }
MAFighter >> moveFrom: anAnt [

	"A Fighter move randomly around the ant hill."

	| newPos antHillPos |
	newPos := anAnt getPosition + ((Random new next * 10 - 5) rounded
	           @ (Random new next * 10 - 5) rounded).
	antHillPos := MASimulationManager simulationAntHillPosition.

	newPos x < (antHillPos x - 40) ifTrue: [ 
		newPos := antHillPos x - 40 @ newPos y ].
	newPos y < (antHillPos y - 40) ifTrue: [ 
		newPos := newPos x @ (antHillPos y - 40) ].
	newPos x > (antHillPos x + 40) ifTrue: [ 
		newPos := antHillPos x + 40 @ newPos y ].
	newPos y > (antHillPos y + 40) ifTrue: [ 
		newPos := newPos x @ (antHillPos y + 40) ].

	^ newPos.

]

{ #category : #events }
MAFighter >> restoreFrom: aMemento [

	
]

{ #category : #events }
MAFighter >> saveForTimeTravel [

	self getTimeTravelServicesProvider save: (MolFighterMemento new save: self)
]
