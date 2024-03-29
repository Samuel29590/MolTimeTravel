"
The actual implementation of the TMAInsectsType: MAInsect, describe one insect. It means that if there are 50 insects on the simulation, there are also 50 instances of MAInsects. This implementation is very simple, insect only move on the ground randomly (waiting to be eaten...) at each step of the simulation.

Variables :

-position, is a point.

-ageInMs, is an integer.
"
Class {
	#name : #MAInsect,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAInsectsType + TMASimulationToGlobalEvents + TimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAInsectsType classTrait + TMASimulationToGlobalEvents classTrait + TimeTravelEvents classTrait',
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
]

{ #category : #'life cycle' }
MAInsect >> componentInitialize [
	
	"Initialization of the MAInsect component."

	self forServices: TMASimulationServices useProvider: #default.
	
	ageInMs := 0.
	position := ((Random new nextIntegerBetween: 1 and: MASimulationManager simulationWidth) @ (Random new nextIntegerBetween: 1 and: MASimulationManager simulationHeight)).
]

{ #category : #'life cycle' }
MAInsect >> componentPassivate [

	"Passivating the MAInsect component."

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAInsect >> componentRemove [

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
MAInsect >> getTimeTravelEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TimeTravelEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TimeTravelEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAInsect >> getTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TimeTravelServices named: servicesSymbol.
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

	self getTimeTravelServicesProvider save: (MolInsectMemento new save: self)
]

{ #category : #'events - lifecycle' }
MAInsect >> simulationStepSent: aStep [

	self doSimulationStep.
]
