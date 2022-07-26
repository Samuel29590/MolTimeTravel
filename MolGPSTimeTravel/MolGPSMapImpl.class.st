Class {
	#name : #MolGPSMapImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'MolGPSMap + MolGPSDataEvents + TimeTravelEvents',
	#classTraits : 'MolGPSMap classTrait + MolGPSDataEvents classTrait + TimeTravelEvents classTrait',
	#category : #MolGPSTimeTravel
}

{ #category : #'component life cycle' }
MolGPSMapImpl >> componentActivate [

	self getMolGPSDataEventsSubscriber subscribe: self.
	
	"--------------------------Time Travel--------------------------"
	"Subscription to the Time Travel event"
	self getTimeTravelEventsSubscriber subscribe: self
	"---------------------------------------------------------------"
]

{ #category : #'component life cycle' }
MolGPSMapImpl >> componentInitialize [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ "Connection to the TimeTravel service."
		self forServices: TimeTravelServices useProvider: #default.
		"Subscription to the Time Travel event"
		self getTimeTravelEventsSubscriber subscribe: self.
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component notifies its creation" 
			self getTimeTravelServicesProvider creationOf: self ] ].
	"---------------------------------------------------------------"
	
	super componentInitialize.
	
	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state." 
			self saveForTimeTravel ] ].
	"---------------------------------------------------------------"
]

{ #category : #'component life cycle' }
MolGPSMapImpl >> componentPassivate [

	self getMolGPSDataEventsSubscriber unsubscribe: self.
	
	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTimeTravelEventsSubscriber unsubscribe: self
	"---------------------------------------------------------------"
]

{ #category : #'component life cycle' }
MolGPSMapImpl >> componentRemove [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"

	super componentRemove.
]

{ #category : #events }
MolGPSMapImpl >> currentPositionChanged: aGeoPosition [

	"Display a circle on the map view at the current position"

	| radius |
	radius := self getMolGPSDataServicesProvider getAccuracyRadiusInMeters.

	self updatePositionCircleOnMap: aGeoPosition radius: radius.
	
		"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ 
			self getTimeTravelServicesProvider
				saveEvent: #currentPositionChanged:
				performBy: self
				withParameters: { aGeoPosition } ] ]
	"---------------------------------------------------------------"
]

{ #category : #'component accessing' }
MolGPSMapImpl >> getMolGPSDataEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := MolGPSDataEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: MolGPSDataEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MolGPSMapImpl >> getMolGPSDataServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := MolGPSDataServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: MolGPSDataServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MolGPSMapImpl >> getTimeTravelEventsSubscriber [
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
MolGPSMapImpl >> getTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #events }
MolGPSMapImpl >> saveForTimeTravel [

	| memento |
	memento := MolMapMemento new.
	self getTimeTravelServicesProvider save: (memento save: self)
]

{ #category : #'map updating' }
MolGPSMapImpl >> updatePositionCircleOnMap: aGeoPosition radius: radius [
	"Update geographic position of the received GPS position circle with a precision radius"
	
	| point text |
	point := aGeoPosition.
	point := point truncateTo: 0.01.
	text := (point x printShowingDecimalPlaces: 2), '@', (point y printShowingDecimalPlaces: 2).
	
	Transcript show: ('[Map] Receive new GPS position: ', text, ' radius: ', radius rounded printString, ' m'); cr.
]
