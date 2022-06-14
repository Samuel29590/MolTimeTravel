Class {
	#name : #MAInsectExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsExperimentalType + TMASimulationExperimentalToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MAInsectExperimental >> componentActivate [

	"Activation of the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber subscribe:
		self
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self
]

{ #category : #'component accessing' }
MAInsectExperimental >> getTMASimulationExperimentalToGlobalEventsSubscriber [
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
MAInsectExperimental >> move [

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
	position := newPos
]

{ #category : #accessing }
MAInsectExperimental >> position [

	^ position
]

{ #category : #accessing }
MAInsectExperimental >> position: anObject [

	position := anObject
]

{ #category : #'events - lifecycle' }
MAInsectExperimental >> simulationStepSent [

	self move.
]
