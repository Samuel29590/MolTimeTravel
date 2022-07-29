Class {
	#name : #MolRandomSenderImpl,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + MolRandomSender + TimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + MolRandomSender classTrait + TimeTravelEvents classTrait',
	#category : #MolRandomPrinterTimeTravel
}

{ #category : #'life cycle' }
MolRandomSenderImpl >> componentInitialize [

	self openInNewSpace
		extent: 350 @ 50;
		title: 'RandomPrinter Sender'.
	self
		background: Color orange;
		relocate: 5 @ 5;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
		padding: (BlInsets
				 top: 8
				 right: 16
				 bottom: 8
				 left: 16);
		layout: BlLinearLayout horizontal;
		effect: (BlGaussianShadowEffect
				 color: (Color black alpha: 0.3)
				 width: 1
				 offset: 0 @ 2);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addEventHandler: (BlEventHandler
				 on: BlClickEvent
				 do: [ :anEvent | 
					 self getMolRandomSenderEventsNotifier 
						 printRandomIntegerSmallerThan: 100.
					 anEvent consumed: true ]);
		addChild: (BlTextElement new text:
					 ('Print random integer smaller than 100' asRopedText
						  foreground: Color black;
						  fontSize: 16;
						  thin)).
]

{ #category : #'life cycle' }
MolRandomSenderImpl >> componentRemove [

	"--------------------------Time Travel--------------------------"
	self getTimeTravelServicesProvider isNotFoundServices ifFalse: [ 
		self getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"

	spaceReference isNull ifFalse:[ spaceReference space close ].
]

{ #category : #'component accessing' }
MolRandomSenderImpl >> getMolRandomSenderEventsNotifier [
	^self eventsNotifiers at: MolRandomSenderEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: MolRandomSenderEvents name: nil].
]

{ #category : #'component accessing' }
MolRandomSenderImpl >> getTimeTravelEventsSubscriber [
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
MolRandomSenderImpl >> getTimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TimeTravelServices named: servicesSymbol.
	^servicesProvider
]
