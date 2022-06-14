Class {
	#name : #MAAntExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsExperimentalType + TMASimulationExperimentalToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MAAntExperimental >> componentActivate [

	"Activation of the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber subscribe:
		self
]

{ #category : #'life cycle' }
MAAntExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self
]

{ #category : #'component accessing' }
MAAntExperimental >> getTMASimulationExperimentalToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationExperimentalToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationExperimentalToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'events - lifecycle' }
MAAntExperimental >> move [

	| newPos |
	newPos := position
	          +
	          ((Random new next * 6 - 3) rounded
	           @ (Random new next * 6 - 3) rounded).

	newPos x < 0 ifTrue: [ newPos := 0 @ newPos y ].
	newPos y < 0 ifTrue: [ newPos := newPos x @ 0 ].
	newPos x > MASimulationManagerExperimental simulationWidth ifTrue: [ 
		newPos := MASimulationManagerExperimental simulationWidth @ newPos y ].
	newPos y > MASimulationManagerExperimental simulationHeight ifTrue: [ 
		newPos := newPos x
		          @ MASimulationManagerExperimental simulationHeight ].
	position := newPos.
]

{ #category : #accessing }
MAAntExperimental >> position [

	^ position
]

{ #category : #accessing }
MAAntExperimental >> position: anObject [

	position := anObject
]

{ #category : #'events - lifecycle' }
MAAntExperimental >> simulationStepSent [

	self move.
]
