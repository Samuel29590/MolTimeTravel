Class {
	#name : #MAInsectExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsExperimentalType + TMASimulationExperimentalToGlobalEvents + TMATimeTravelExperimentalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait + TMATimeTravelExperimentalEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAInsectExperimental >> ageInMs [

	^ ageInMs
]

{ #category : #accessing }
MAInsectExperimental >> ageInMs: anObject [

	ageInMs := anObject
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentActivate [

	"Activation of the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber subscribe:
		self.

	self getTMATimeTravelExperimentalEventsSubscriber subscribe: self.

	self
		forEvents: TMATimeTravelExperimentalEvents
		addProducer: 'TimeTravel'
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentInitialize [

	"Initialization of the MAAnt component."

	self
		forServices: TMATimeTravelExperimentalServices
		useProvider: #TimeTravel.

	ageInMs := 0
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self.
		
	self getTMATimeTravelExperimentalEventsSubscriber unsubscribe: self
]

{ #category : #'component accessing' }
MAInsectExperimental >> getTMAInsectsEventsNotifier [
	^self eventsNotifiers at: TMAInsectsEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAInsectsEvents name: nil].
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

{ #category : #'component accessing' }
MAInsectExperimental >> getTMATimeTravelExperimentalEventsSubscriber [
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
MAInsectExperimental >> getTMATimeTravelExperimentalServicesProvider [
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
MAInsectExperimental >> move [

	| newPos oldPosition |
	oldPosition := position.
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
	
	self getTMAInsectsEventsNotifier positionChangedFor: self oldPos: oldPosition newPos: position.
	
	
	
]

{ #category : #accessing }
MAInsectExperimental >> position [

	^ position
]

{ #category : #accessing }
MAInsectExperimental >> position: anObject [

	position := anObject
]

{ #category : #events }
MAInsectExperimental >> restore: aComponentName values: aMemento [

	self componentName = aComponentName ifTrue: [ 
		position := aMemento position.
		ageInMs := aMemento ageInMs ]
]

{ #category : #'events - lifecycle' }
MAInsectExperimental >> simulationStepSent: aStep [

	| memento |
	memento := MAInsectMemento new.

	"age of the insect increase"
	ageInMs := aStep
	           *
	           MASimulationManagerExperimental simulationStepDurationInMs.

	"insect move"
	self move.

	"insect save it state"
	self getTMATimeTravelExperimentalServicesProvider
		save: (memento save: self)
		at: aStep
]
