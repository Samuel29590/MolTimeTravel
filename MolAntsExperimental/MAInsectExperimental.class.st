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

{ #category : #'life cycle' }
MAInsectExperimental >> componentActivate [

	"Activation of the MAInsect component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber subscribe:
		self.

	self getTMATimeTravelExperimentalEventsSubscriber subscribe: self.

	self
		forEvents: TMATimeTravelExperimentalEvents
		addProducer: 'TimeTravel'
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentInitialize [

	"Initialization of the MAInsect component."

	self
		forServices: TMATimeTravelExperimentalServices
		useProvider: #TimeTravel.

	ageInMs := 0.

	self getTMATimeTravelExperimentalServicesProvider isRestoring 
		ifFalse: [ "insect notify the creation"
			self getTMATimeTravelExperimentalServicesProvider
				creationOf: self
				at: self getTMASimulationExperimentalServicesProvider step ]
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentPassivate [

	"Passivating the MAInsect component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self.

	self getTMATimeTravelExperimentalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAInsectExperimental >> componentRemove [

	"Insect notify its remove"

	self getTMATimeTravelExperimentalServicesProvider isRestoring 
		ifFalse: [ 
			self getTMATimeTravelExperimentalServicesProvider
				removeOf: self
				at: self getTMASimulationExperimentalServicesProvider step ]
]

{ #category : #'component accessing' }
MAInsectExperimental >> getTMAInsectsEventsNotifier [
	^self eventsNotifiers at: TMAInsectsEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAInsectsEvents name: nil].
]

{ #category : #'component accessing' }
MAInsectExperimental >> getTMASimulationExperimentalServicesProvider [
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

	"Random move on the ground."
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

	self getTMAInsectsEventsNotifier
		positionChangedFor: self
		oldPos: oldPosition
		newPos: position
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
MAInsectExperimental >> restoreFrom: aMemento [

		position := aMemento position.
		ageInMs := aMemento ageInMs
]

{ #category : #'events - lifecycle' }
MAInsectExperimental >> simulationStepSent: aStep [

	| memento |
	memento := MAInsectMementoExperimental new.

	"age of the insect increase"
	ageInMs := aStep
	           *
	           MASimulationManagerExperimental simulationStepDurationInMs.

	"insect move"
	self move.

	"insect save its state"
	self getTMATimeTravelExperimentalServicesProvider
		save: (memento save: self)
		at: aStep
]
