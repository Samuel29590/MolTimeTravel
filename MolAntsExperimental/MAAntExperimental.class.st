Class {
	#name : #MAAntExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsExperimentalType + TMASimulationExperimentalToGlobalEvents + TMATimeTravelExperimentalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait + TMATimeTravelExperimentalEvents classTrait',
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
		self.

	self getTMATimeTravelExperimentalEventsSubscriber subscribe: self.
	
		self forEvents: TMATimeTravelExperimentalEvents addProducer: 'TimeTravel'.
]

{ #category : #'life cycle' }
MAAntExperimental >> componentInitialize [

	"Initialization of the MAAnt component."

	self
		forServices: TMATimeTravelExperimentalServices
		useProvider: #TimeTravel.

	ageInMs := 0
]

{ #category : #'life cycle' }
MAAntExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self.

	self getTMATimeTravelExperimentalEventsSubscriber unsubscribe: self.
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

{ #category : #'component accessing' }
MAAntExperimental >> getTMATimeTravelExperimentalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMATimeTravelExperimentalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMATimeTravelExperimentalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAAntExperimental >> getTMATimeTravelExperimentalServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMATimeTravelExperimentalServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMATimeTravelExperimentalServices named: servicesSymbol]. 
	^servicesProvider
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

{ #category : #events }
MAAntExperimental >> restore: aComponentName value: componentValues [

	self componentName = aComponentName ifTrue: [ 
		position := componentValues ]
]

{ #category : #'events - lifecycle' }
MAAntExperimental >> simulationStepSent: aStep [

	self move.
	self getTMATimeTravelExperimentalServicesProvider
		save: self
		at: aStep
]
