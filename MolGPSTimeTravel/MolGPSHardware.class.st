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

	"Start a thread to simulate sending of a fixed geo position each 2 seconds"
	sendCurrentPositionThread := [ 
	                             [ true ] whileTrue: [ 
		                             (Delay forSeconds: 1) wait.

		                          	"--------------------------Time Travel--------------------------"
												self getTimeTravelServicesProvider isNotFoundServices ifFalse: [
				                             self getTimeTravelServicesProvider
					                             isRestoring ifFalse: [
											"---------------------------------------------------------------"
					                             self getMolGPSDataEventsNotifier 
						                             currentPositionChanged: 1 @ 1.

					                             "--------------------------Time Travel--------------------------"
					                             self getTimeTravelServicesProvider
						                             saveTheApplication
					                             "---------------------------------------------------------------" ] ]
			                             ifTrue: [ 
				                             self getMolGPSDataEventsNotifier 
						                             currentPositionChanged: 1 @ 1 ] ] ] forkAt:
		                             Processor userBackgroundPriority
]

{ #category : #'life cycle' }
MolGPSHardware >> componentPassivate [
	
	sendCurrentPositionThread ifNotNil: [ :e | e terminate ].
	sendCurrentPositionThread := nil.
]

{ #category : #services }
MolGPSHardware >> getAccuracyRadiusInMeters [
	
	"--------------------------Time Travel--------------------------"
	self getTimeTravelServicesProvider isNotFoundServices ifFalse: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ 
			self getTimeTravelServicesProvider
				saveService: #getAccuracyRadiusInMeters
				performBy: self
				withParameters: {}
				needToReplay: false ] ].
	"---------------------------------------------------------------"

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
MolGPSHardware >> restoreFrom: aMemento [

]

{ #category : #events }
MolGPSHardware >> saveForTimeTravel [

	self getTimeTravelServicesProvider save: (MolHardwareMemento new save: self)
]
