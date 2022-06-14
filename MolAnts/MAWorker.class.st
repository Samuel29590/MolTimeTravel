"
I'm the actual implementation of the worker role.

MAWorker variables :

-phase, is a symbol to represent the actual phase of the ant: explore of return.

-oldPositions, is and ordered collection of 5 points used by the worker role do not move on the last 5 position the worker already visit.
"
Class {
	#name : #MAWorker,
	#superclass : #MARole,
	#category : #MolAnts
}

{ #category : #'life cycle' }
MAWorker >> componentInitialize [

	"Initialization of the MAWorker component."

	roleName := #worker.
]

{ #category : #role }
MAWorker >> doSimulationStepFor: anAnt [

]

{ #category : #position }
MAWorker >> moveFrom: anAnt [

	| newPos |
	newPos := anAnt position
	          +
	          ((Random new next * 6 - 3) rounded
	           @ (Random new next * 6 - 3) rounded).


	newPos x < 0 ifTrue: [ newPos := 0 @ newPos y ].
	newPos y < 0 ifTrue: [ newPos := newPos x @ 0 ].
	newPos x > MASimulationManager simulationWidth ifTrue: [ 
		newPos := MASimulationManager simulationWidth @ newPos y ].
	newPos y > MASimulationManager simulationHeight ifTrue: [ 
		newPos := newPos x @ MASimulationManager simulationHeight ].
	^ newPos
]
