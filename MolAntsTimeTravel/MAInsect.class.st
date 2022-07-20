"
The actual implementation of the TMAInsectsType: MAInsect, describe one insect. It means that if there are 50 insects on the simulation, there are also 50 instances of MAInsects. This implementation is very simple, insect only move on the ground randomly (waiting to be eaten...) at each step of the simulation.

Variables :

-position, is a point.

-ageInMs, is an integer.
"
Class {
	#name : #MAInsect,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsType + TMASimulationToGlobalEvents + TMATimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsType classTrait + TMASimulationToGlobalEvents classTrait + TMATimeTravelEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #'life cycle' }
MAInsect >> componentActivate [

	"Activation of the MAInsect component."

	self getTMASimulationToGlobalEventsSubscriber subscribe: self.

	"--------------------------Time Travel--------------------------"
	"Subscription to the Time Travel event"
	self getTMATimeTravelEventsSubscriber subscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAInsect >> componentInitialize [

	"--------------------------Time Travel--------------------------"
	"Connection to the TimeTravel service."
	self forServices: TMATimeTravelServices useProvider: #default.
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component notifies its creation" 
			self getTMATimeTravelServicesProvider creationOf: self ] ].
	"---------------------------------------------------------------"
	
	"Initialization of the MAInsect component."

	self forServices: TMASimulationServices useProvider: #default.
	
	ageInMs := 0.
	position := ((Random new nextIntegerBetween: 1 and: MASimulationManager simulationWidth) @ (Random new nextIntegerBetween: 1 and: MASimulationManager simulationHeight)).

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component saves its state."
			self saveForTimeTravel ] ].
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAInsect >> componentPassivate [

	"Passivating the MAInsect component."

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self.
	
	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTMATimeTravelEventsSubscriber unsubscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAInsect >> componentRemove [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTMATimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"
	
	"Removing the MAInsect component."

	position := nil.
	ageInMs := nil
]

{ #category : #'life cycle' }
MAInsect >> doSimulationStep [

	"At each step an insect just move randomly, waiting to be eaten ..."

		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self position: position
			+
			((Random new next * 2 - 1) rounded
			 @ (Random new next * 2 - 1) rounded) 
]

{ #category : #accessing }
MAInsect >> getAgeInMs [

	^ ageInMs
]

{ #category : #'life cycle' }
MAInsect >> getPosition [

	^ position
]

{ #category : #'component accessing' }
MAInsect >> getTMAInsectEventsNotifier [
	^self eventsNotifiers at: TMAInsectEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAInsectEvents name: nil].
]

{ #category : #'component accessing' }
MAInsect >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMASimulationServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MAInsect >> getTMASimulationToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAInsect >> getTMATimeTravelEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMATimeTravelEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMATimeTravelEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAInsect >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'life cycle' }
MAInsect >> position: aPoint [

	| oldPos |
	position ~= aPoint ifFalse: [ ^ self ].
	oldPos := position.
	position := aPoint.

	position x < 0 ifTrue: [ position := 0 @ position y ].
	position y < 0 ifTrue: [ position := position x @ 0 ].
	position x >= MASimulationManager simulationWidth ifTrue: [ 
		position := MASimulationManager simulationHeight @ position y ].
	position y >= MASimulationManager simulationHeight ifTrue: [ 
		position := position x @ MASimulationManager simulationWidth ].

	self getTMAInsectEventsNotifier 
		positionChangedFor: self
		oldPos: oldPos
		newPos: position
]

{ #category : #events }
MAInsect >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	position := aMemento getPosition.
	ageInMs := aMemento getAgeInMs
]

{ #category : #events }
MAInsect >> saveForTimeTravel [

		| memento |
	memento := MAInsectMemento new.

	self getTMATimeTravelServicesProvider
		save: (memento save: self)
]

{ #category : #'events - lifecycle' }
MAInsect >> simulationStepSent: aStep [

	self doSimulationStep.

	"self saveForTimeTravel: aStep"
]
