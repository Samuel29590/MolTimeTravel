Class {
	#name : #MolGPSDataImpl,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'MolGPSData + MolGPSDataServices + TimeTravelEvents',
	#classTraits : 'MolGPSData classTrait + MolGPSDataServices classTrait + TimeTravelEvents classTrait',
	#instVars : [
		'accuracy',
		'sendCurrentPositionThread'
	],
	#category : #MolGPSTimeTravel
}

{ #category : #accessing }
MolGPSDataImpl >> accuracy [

	^ accuracy
]

{ #category : #accessing }
MolGPSDataImpl >> accuracy: anObject [

	accuracy := anObject
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentActivate [

	"Start a thread to simulate sending of the geo position each seconds and accuracy precision"

	"--------------------------Time Travel--------------------------"

	"Subscription to the Time Travel event"

	self getTimeTravelEventsSubscriber subscribe: self.
	"---------------------------------------------------------------"

	sendCurrentPositionThread := [ 
	                             [ true ] whileTrue: [ 
		                             (Delay forMilliseconds: 50) wait.

		                           	"--------------------------Time Travel--------------------------"
		                             (MolUtils
			                              instanceOf: MolTimeTravel
			                              named: #default)
			                             ifNotNil: [ 
				                             self getTimeTravelServicesProvider
					                             isRestoring ifFalse: [ 
											"---------------------------------------------------------------"
					                             self getMolGPSDataEventsNotifier 
						                             currentPositionChanged:
						                             self getRandomizedGPSPosition.

					                             self increaseAccuracy.

					                             "--------------------------Time Travel--------------------------"
					                             "save the system for TimeTravel."
					                             self getTimeTravelServicesProvider
						                             saveTheApplication
					                             "---------------------------------------------------------------" ] ]
			                             ifNil: [ 
				                             self getMolGPSDataEventsNotifier 
					                             currentPositionChanged:
					                             self getRandomizedGPSPosition.

				                             self increaseAccuracy ] ] ] forkAt:
		                             Processor userBackgroundPriority
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentInitialize [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ "Connection to the TimeTravel service."
		self forServices: TimeTravelServices useProvider: #default.
		"Subscription to the Time Travel event"
		self getTimeTravelEventsSubscriber subscribe: self.
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component notifies its creation" 
			self getTimeTravelServicesProvider creationOf: self ] ].
	"---------------------------------------------------------------"
	
	"Set starting accuracy"
	self accuracy: 1000.
	
	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state." 
			self saveForTimeTravel ] ].
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentPassivate [

	sendCurrentPositionThread ifNotNil: [ :e | e terminate ].
	sendCurrentPositionThread := nil.
	
	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTimeTravelEventsSubscriber unsubscribe: self
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MolGPSDataImpl >> componentRemove [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"
]

{ #category : #services }
MolGPSDataImpl >> getAccuracyRadiusInMeters [
	"Get and return the accuracy of the GPS depending quality of signal and quantity of connected satellites"

	^self accuracy 
]

{ #category : #'component accessing' }
MolGPSDataImpl >> getMolGPSDataEventsNotifier [
	^self eventsNotifiers at: MolGPSDataEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: MolGPSDataEvents name: nil].
]

{ #category : #private }
MolGPSDataImpl >> getRandomizedGPSPosition [

	| random |
	random := Random new.
	^ random next @ random next
]

{ #category : #'component accessing' }
MolGPSDataImpl >> getTimeTravelEventsSubscriber [
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
MolGPSDataImpl >> getTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #private }
MolGPSDataImpl >> increaseAccuracy [

	| nextAccuracy |
	self accuracy > 1 ifTrue: [
		nextAccuracy := self accuracy - (0.1 * self accuracy). "10% better precision at each times"
		nextAccuracy < 1 ifTrue: [ "stay to 1" nextAccuracy := 1 ].
		self accuracy: nextAccuracy 
	]
]

{ #category : #events }
MolGPSDataImpl >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	accuracy  := aMemento getAccuracy.
]

{ #category : #events }
MolGPSDataImpl >> saveForTimeTravel [

	| memento |
	memento := MolDataMemento new.
	self getTimeTravelServicesProvider save: (memento save: self)
]
