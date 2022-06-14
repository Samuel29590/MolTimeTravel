"
I'm the actual implementation of the queen role.
"
Class {
	#name : #MAQueen,
	#superclass : #MARole,
	#instVars : [
		'compt'
	],
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAQueen >> componentInitialize [

	"Initialization of the MAQueen component."

	roleName := #queen.
	compt := 2.
]

{ #category : #role }
MAQueen >> doSimulationStepFor: anAnt [

	compt > 0 ifTrue: [ 
		compt := compt - 1.
		self getTMARoleEventsNotifier queenLaid ]
]

{ #category : #role }
MAQueen >> moveFrom: anAnt [

	"A queen don't move."

	^ anAnt position
]
