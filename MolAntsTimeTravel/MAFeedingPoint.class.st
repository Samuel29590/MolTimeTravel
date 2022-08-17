"
The actual implementation of the TMAFeedingPointType: MAFeedingPoint, describe one feeding point. This implementation is very simple, feeding point only receive eated message. This message decrease their capacity and when their capacity is equal to 0 the feeding point disappear from the ground.

Variables :

-position, is a point.

-capacity, is an integer.
"
Class {
	#name : #MAFeedingPoint,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAFeedingPointType + TMAFeedingPointServices + TimeTravelEvents + TMASimulationToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAFeedingPointType classTrait + TMAFeedingPointServices classTrait + TimeTravelEvents classTrait + TMASimulationToGlobalEvents classTrait',
	#instVars : [
		'position',
		'capacity'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #'life cycle' }
MAFeedingPoint >> componentActivate [

	self getTMASimulationToGlobalEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentInitialize [
	
	"Initialization of the MAFeedingPoint component."
	
	self forServices: TMASimulationServices useProvider: #default.

	capacity := 10.
	position := (Random new
		             nextIntegerBetween: 1
		             and: MASimulationManager simulationWidth)
	            @ (Random new
			             nextIntegerBetween: 1
			             and: MASimulationManager simulationHeight).
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentPassivate [

	"Passivating the MAFeedingPoint component."

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self.
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentRemove [

	"Removing the MAFeedingPoint component."

	position := nil.
	capacity := nil
]

{ #category : #events }
MAFeedingPoint >> eated [

	capacity := capacity - 1.
	^ capacity
]

{ #category : #accessing }
MAFeedingPoint >> getCapacity [

	^ capacity 
]

{ #category : #accessing }
MAFeedingPoint >> getPosition [

	^position
]

{ #category : #'component accessing' }
MAFeedingPoint >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMASimulationServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MAFeedingPoint >> getTMASimulationToGlobalEventsSubscriber [
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
MAFeedingPoint >> getTimeTravelEventsSubscriber [
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
MAFeedingPoint >> getTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #events }
MAFeedingPoint >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	position := aMemento getPosition.
	capacity := aMemento getCapacity.
]

{ #category : #events }
MAFeedingPoint >> saveForTimeTravel [

	self getTimeTravelServicesProvider save: (MolFeedingPointMemento new save: self)
]

{ #category : #'events - lifecycle' }
MAFeedingPoint >> simulationStepSent: aStep [

	"self saveForTimeTravel: aStep"
]
