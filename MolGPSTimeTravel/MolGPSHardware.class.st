Class {
	#name : #MolGPSHardware,
	#superclass : #Object,
	#traits : 'MolComponentImpl + MolGPSData + MolGPSDataServices + TimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + MolGPSData classTrait + MolGPSDataServices classTrait + TimeTravelEvents classTrait',
	#instVars : [
		'sendCurrentPositionThread'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #'life cycle' }
MolGPSHardware >> componentActivate [

	"--------------------------Time Travel--------------------------"

	"Subscription to the Time Travel event"

	self getTimeTravelEventsSubscriber subscribe: self.
	"---------------------------------------------------------------"

	"Start a thread to simulate sending of a fixed geo position each 2 seconds"
	sendCurrentPositionThread := [ 
	                             [ true ] whileTrue: [ 
		                             (Delay forSeconds: 1) wait.

		                          	"--------------------------Time Travel--------------------------"
		                             (MolUtils
			                              instanceOf: MolTimeTravel
			                              named: #default)
			                             ifNotNil: [ 
				                             self getTimeTravelServicesProvider
					                             isRestoring ifFalse: [ 											"---------------------------------------------------------------"
					                             self getMolGPSDataEventsNotifier 
						                             currentPositionChanged: 1 @ 1.

					                             "--------------------------Time Travel--------------------------"
					                             self getTimeTravelServicesProvider
						                             saveTheApplication
					                             "---------------------------------------------------------------" ] ]
			                             ifNil: [ 
				                             self getMolGPSDataEventsNotifier 
						                             currentPositionChanged: 1 @ 1 ] ] ] forkAt:
		                             Processor userBackgroundPriority
]

{ #category : #'life cycle' }
MolGPSHardware >> componentInitialize [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ "Connection to the TimeTravel service."
		self forServices: TimeTravelServices useProvider: #default.
		"Subscription to the Time Travel event"
		self getTimeTravelEventsSubscriber subscribe: self.
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component notifies its creation" 
			self getTimeTravelServicesProvider creationOf: self ] ].
	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state." 
			self saveForTimeTravel ] ].
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MolGPSHardware >> componentPassivate [
	
	sendCurrentPositionThread ifNotNil: [ :e | e terminate ].
	sendCurrentPositionThread := nil.
	
	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTimeTravelEventsSubscriber unsubscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MolGPSHardware >> componentRemove [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"
	
]

{ #category : #services }
MolGPSHardware >> getAccuracyRadiusInMeters [
	"Get and return the accuracy of the GPS depending quality of signal and quantity of connected satellites"
	
	"convert precision in feet to meters"
	^(self precision * 0.3048)
]

{ #category : #'component accessing' }
MolGPSHardware >> getMolGPSDataEventsNotifier [
	^self eventsNotifiers at: MolGPSDataEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: MolGPSDataEvents name: nil].
]

{ #category : #'component accessing' }
MolGPSHardware >> getTimeTravelEventsSubscriber [
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
MolGPSHardware >> getTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'GPS hardware existing API' }
MolGPSHardware >> precision [

	"Return GPS hardware precision (in feet)"

	^3
]

{ #category : #events }
MolGPSHardware >> saveForTimeTravel [

	| memento |
	memento := MolHardwareMemento new.
	self getTimeTravelServicesProvider save: (memento save: self)
]
