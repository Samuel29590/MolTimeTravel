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

{ #category : #accessing }
MAAntExperimental >> ageInMs [

	^ ageInMs
]

{ #category : #accessing }
MAAntExperimental >> ageInMs: anObject [

	ageInMs := anObject
]

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
	self
		forServices: TMASimulationExperimentalServices
		useProvider: #default.

	ageInMs := 0.

	self getTMATimeTravelExperimentalServicesProvider isRestoring 
		ifFalse: [ "ant notify the creation"
			self getTMATimeTravelExperimentalServicesProvider
				creationOf: self
				at: self getTMASimulationExperimentalServicesProvider step ]
]

{ #category : #'life cycle' }
MAAntExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self.

	self getTMATimeTravelExperimentalEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAAntExperimental >> componentRemove [

	"ant notify the remove"
	self getTMATimeTravelExperimentalServicesProvider isRestoring 
		ifFalse: [ 
			self getTMATimeTravelExperimentalServicesProvider
				removeOf: self
				at: self getTMASimulationExperimentalServicesProvider step ]
]

{ #category : #'events - lifecycle' }
MAAntExperimental >> doSimulationStep: aStep [

	| antRectangle |
	"age of the ant increase"
	ageInMs := aStep
	           *
	           MASimulationManagerExperimental simulationStepDurationInMs.

	"Detection of insects and eat if one is near."
	antRectangle := BlBounds origin: position - (30 @ 30) extent: 60 @ 60.
	self getTMASimulationExperimentalServicesProvider insects keysDo: [ 
		:each | 
		| insectRectangle |
		insectRectangle := BlBounds origin: each extent: 0 @ 0.
		(antRectangle intersects: insectRectangle) ifTrue: [ 
			self getTMAAntsEventsNotifier ant: self eatAt: each ] ]
]

{ #category : #'component accessing' }
MAAntExperimental >> getTMAAntsEventsNotifier [
	^self eventsNotifiers at: TMAAntsEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAAntsEvents name: nil].
]

{ #category : #'component accessing' }
MAAntExperimental >> getTMASimulationExperimentalServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMASimulationExperimentalServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMASimulationExperimentalServices named: servicesSymbol]. 
	^servicesProvider
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
MAAntExperimental >> restore: aComponentName values: aMemento [

	self componentName = aComponentName ifTrue: [ 
		position := aMemento position.
		ageInMs := aMemento ageInMs ]
]

{ #category : #events }
MAAntExperimental >> restoreFrom: aMemento [

		position := aMemento position.
		ageInMs := aMemento ageInMs
]

{ #category : #'events - lifecycle' }
MAAntExperimental >> simulationStepSent: aStep [

	| memento |
	memento := MAAntMemento new.

	"ant do actions"
	self doSimulationStep: aStep.
	
	"ant move"
	self move.

	"ant save it state"
	self getTMATimeTravelExperimentalServicesProvider
		save: (memento save: self)
		at: aStep

]
