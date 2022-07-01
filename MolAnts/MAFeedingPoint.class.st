"
The actual implementation of the TMAFeedingPointType: MAFeedingPoint, describe one feeding point. This implementation is very simple, feeding point only receive eated message. This message decrease their capacity and when their capacity is equal to 0 the feeding point disappear from the ground.

Variables :

-position, is a point.

-capacity, is an integer.
"
Class {
	#name : #MAFeedingPoint,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAFeedingPointType + TMAFeedingPointServices + TMATimeTravelExperimentalEvents + TMATimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAFeedingPointType classTrait + TMAFeedingPointServices classTrait + TMATimeTravelExperimentalEvents classTrait + TMATimeTravelEvents classTrait',
	#instVars : [
		'position',
		'capacity'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAFeedingPoint >> capacity [

	^ capacity 
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentActivate [

	"here write the code corresponding to component activation phase"

	.self getTMATimeTravelEventsSubscriber subscribe: self.
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentInitialize [

	capacity := 10.
	position := (Random new
		             nextIntegerBetween: 1
		             and: MASimulationManager simulationWidth)
	            @ (Random new
			             nextIntegerBetween: 1
			             and: MASimulationManager simulationHeight).
			
	self forServices: TMATimeTravelServices useProvider: #TimeTravel.

	self forServices: TMASimulationServices useProvider: #default.

	self getTMATimeTravelServicesProvider isRestoring ifFalse: [ "feedingPoint notify the creation"
		self getTMATimeTravelServicesProvider
			creationOf: self
			at: self getTMASimulationServicesProvider step ]
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentPassivate [


.
	self getTMATimeTravelEventsSubscriber unsubscribe: self

	
]

{ #category : #'life cycle' }
MAFeedingPoint >> componentRemove [


		"feedingPoint notify its remove"
	self getTMATimeTravelServicesProvider isRestoring 
		ifFalse: [ 
			self getTMATimeTravelServicesProvider
				removeOf: self
				at: self getTMASimulationServicesProvider step ]
]

{ #category : #events }
MAFeedingPoint >> eated [

	capacity := capacity - 1.
	^ capacity
]

{ #category : #'component accessing' }
MAFeedingPoint >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMASimulationServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #'component accessing' }
MAFeedingPoint >> getTMATimeTravelEventsSubscriber [
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
MAFeedingPoint >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #accessing }
MAFeedingPoint >> position [

	^position
]

{ #category : #events }
MAFeedingPoint >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	position := aMemento position.
	capacity := aMemento capacity.
]
