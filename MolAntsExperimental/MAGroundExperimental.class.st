Class {
	#name : #MAGroundExperimental,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundExperimentalType + TMASimulationExperimentalToGlobalEvents + TMATimeTravelExperimentalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait + TMATimeTravelExperimentalEvents classTrait',
	#instVars : [
		'mySpace',
		'refreshing',
		'stepView',
		'nbAntsView',
		'nbInsectsView',
		'returningStepView',
		'storageView',
		'labelText',
		'label'
	],
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MAGroundExperimental >> componentActivate [

	"Activation of the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber subscribe:
		self.
		
		self getTMATimeTravelExperimentalEventsSubscriber subscribe:
		self
]

{ #category : #'life cycle' }
MAGroundExperimental >> componentInitialize [

	"Initialization of the MAGround component."

	mySpace := self openInNewSpace extent:
		           MASimulationManagerExperimental simulationWidth
		           @
		           (MASimulationManagerExperimental simulationHeight + 500).

	self createInfoPanel
]

{ #category : #'life cycle' }
MAGroundExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber 
		unsubscribe: self.
		
	self getTMATimeTravelExperimentalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAGroundExperimental >> componentRemove [

	"Removing the MAGround component."

	self stopped.
	mySpace ifNotNil: [ mySpace close ]
]

{ #category : #initialization }
MAGroundExperimental >> createInfoPanel [

	"Initialize the info panel of the view. It initialize each item of the panel (buttons, texts ...)."

	| infoPanel button |
	infoPanel := BlElement new.
	infoPanel background: Color lightGray.
	infoPanel relocate:
		0 @ MASimulationManagerExperimental simulationHeight.
	infoPanel size: MASimulationManagerExperimental simulationWidth @ 300.
	infoPanel constraintsDo: [ :c | 
		c maxHeight: 300.
		c maxWidth: MASimulationManagerExperimental simulationWidth ].
	mySpace addChild: infoPanel.


	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding Pause button"
	button := BlElement new
		          background: Color orange;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 @ 10;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self isRunning ifTrue: [ 
									           self isRestoring ifFalse: [ 
											           MASimulationManagerExperimental pauseSimulation ] ] ].
					           anEvent consumed: true ]).
	labelText := 'Pause' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	infoPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding Play button"
	button := BlElement new
		          background: Color green;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10
			          * 4.5 @ 10;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self isRunning ifFalse: [ 
									           self isRestoring ifFalse: [ 
											           MASimulationManagerExperimental playSimulation ] ] ].
					           anEvent consumed: true ]).
	labelText := 'Play' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	infoPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding Stop button"
	button := BlElement new
		          background: Color red;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 * 8
			          @ 10;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           MASimulationManagerExperimental stopSimulation ].
					           anEvent consumed: true ]).
	labelText := 'Stop' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	infoPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Ajout de l'heure à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 @ 80;
			  background: Color transparent) text: 'Step :' asRopedText).
	stepView := BlTextElement new
		            relocate:
			            MASimulationManagerExperimental simulationWidth / 10
			            @ 100;
		            background: Color transparent;
		            text: '000' asRopedText.
	infoPanel addChild: stepView.


	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Ajout du nombre de proies à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 @ 150;
			  background: Color transparent) text:
			 'Number of insects :' asRopedText).
	nbInsectsView := BlTextElement new
		                 relocate:
			                 MASimulationManagerExperimental simulationWidth
			                 / 10 @ 170;
		                 background: Color transparent;
		                 text: '000' asRopedText.
	infoPanel addChild: nbInsectsView.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Ajout du nombre de fourmis à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 * 4 @ 150;
			  background: Color transparent) text:
			 'Number of ants :' asRopedText).
	nbAntsView := BlTextElement new
		              relocate:
			              MASimulationManagerExperimental simulationWidth / 10
			              * 4 @ 170;
		              background: Color transparent;
		              text: '000' asRopedText.
	infoPanel addChild: nbAntsView.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Ajout du storage à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 * 7 @ 150;
			  background: Color transparent) text: 'Storage :' asRopedText).
	storageView := BlTextElement new
		               relocate:
			               MASimulationManagerExperimental simulationWidth / 10
			               * 7 @ 170;
		               background: Color transparent;
		               text: '000' asRopedText.
	infoPanel addChild: storageView.

	self createTimeTravelPanel
]

{ #category : #initialization }
MAGroundExperimental >> createTimeTravelPanel [

	| timeTravelPanel button |
	timeTravelPanel := BlElement new.
	timeTravelPanel background: Color gray.
	timeTravelPanel relocate:
		0 @ (MASimulationManagerExperimental simulationHeight + 300).
	timeTravelPanel size:
		MASimulationManagerExperimental simulationWidth @ 200.
	timeTravelPanel constraintsDo: [ :c | 
		c maxHeight: 200.
		c maxWidth: MASimulationManagerExperimental simulationWidth ].
	mySpace addChild: timeTravelPanel.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Ajout du returningStep à l'interface."
	timeTravelPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 @ 20;
			  background: Color transparent) text:
			 'Returning Step :' asRopedText).
	returningStepView := BlTextElement new
		                     relocate:
			                     MASimulationManagerExperimental
				                     simulationWidth / 10 @ 40;
		                     background: Color transparent;
		                     text: '000' asRopedText.
	timeTravelPanel addChild: returningStepView.
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding the Start time trave button"
	button := BlElement new
		          background: Color white;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 @ 80;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self isRunning
								           ifTrue: [ 
									           self isRestoring ifFalse: [ 
											           self
												           getTMASimulationExperimentalServicesProvider
												           startTimeTravel ] ]
								           ifFalse: [ 
									           self isRestoring ifFalse: [ 
											           MASimulationManagerExperimental playSimulation.
											           self
												           getTMASimulationExperimentalServicesProvider
												           startTimeTravel ] ] ].
					           anEvent consumed: true ]).
	labelText := 'Start time travel' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding the Stop time trave button"
	button := BlElement new
		          background: Color white;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 * 3
			          @ 80;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self isRunning ifFalse: [ 
									           self isRestoring ifTrue: [ 
											           self
												           getTMASimulationExperimentalServicesProvider
												           stopTimeTravel ] ] ].
					           anEvent consumed: true ]).
	labelText := 'Stop time travel' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding One Step before button"
	button := BlElement new
		          background: Color white;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 * 5
			          @ 80;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self getTMASimulationExperimentalServicesProvider
								           restoreOneStepBefore ].
					           anEvent consumed: true ]).
	labelText := 'One step before' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding One Step after button"
	button := BlElement new
		          background: Color white;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 * 7
			          @ 80;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self getTMASimulationExperimentalServicesProvider
								           restoreOneStepAfter ].
					           anEvent consumed: true ]).
	labelText := 'One step after' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button.


	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding playing backward button"
	button := BlElement new
		          background: Color white;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 * 3
			          @ 130;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self getTMASimulationExperimentalServicesProvider
								           playBackward ].
					           anEvent consumed: true ]).
	labelText := 'Play Backward' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding replay button"
	button := BlElement new
		          background: Color white;
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
		          relocate:
			          MASimulationManagerExperimental simulationWidth / 10 * 5
			          @ 130;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
							           self getTMASimulationExperimentalServicesProvider
								           replay ].
					           anEvent consumed: true ]).
	labelText := 'Relay' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button
]

{ #category : #initialization }
MAGroundExperimental >> doSimulationStep [

	"Incrementing the number of step, then refreshing the view if it's necessary."

	 self updateInfoPanel
]

{ #category : #initialization }
MAGroundExperimental >> drawOnSpartaCanvas: aCanvas [

	"Re writing this method here, in order to directly draw inside the canvas all the elements of the system. Tihs permit to keep good performances even if there is a lot of elements to draw."

	super drawOnSpartaCanvas: aCanvas.

	self getTMASimulationExperimentalServicesProvider getAnts ifNotNil: [ 
		self getTMASimulationExperimentalServicesProvider getAnts do: [ :ant | 
			aCanvas figure
				path: (aCanvas shape circleAt: ant position radius: 5);
				background: Color orange;
				backgroundAlpha: 1;
				draw ] ].

	self getTMASimulationExperimentalServicesProvider getInsects 
		ifNotNil: [ 
			self getTMASimulationExperimentalServicesProvider getInsects keysAndValuesDo: [ 
				:position :insects | 
				aCanvas figure
					path: (aCanvas shape circleAt: position radius: 5);
					background: Color black;
					backgroundAlpha: 1;
					draw ] ]
]

{ #category : #'component accessing' }
MAGroundExperimental >> getTMASimulationExperimentalServicesProvider [
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
MAGroundExperimental >> getTMASimulationExperimentalToGlobalEventsSubscriber [
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
MAGroundExperimental >> getTMATimeTravelExperimentalEventsSubscriber [
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
MAGroundExperimental >> getTMATimeTravelExperimentalServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMATimeTravelExperimentalServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMATimeTravelExperimentalServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #initialization }
MAGroundExperimental >> isRestoring [

	^ self getTMASimulationExperimentalServicesProvider isRestoring
]

{ #category : #initialization }
MAGroundExperimental >> isRunning [

	^ self getTMASimulationExperimentalServicesProvider isRunning
]

{ #category : #initialization }
MAGroundExperimental >> updateInfoPanel [

	"Modify each elements of the info panel. It permit to keep the view up to date with the simulation."

	returningStepView text:
		self getTMASimulationExperimentalServicesProvider getReturningStep
			asRopedText.
	stepView text:
		self getTMASimulationExperimentalServicesProvider getStep
			asRopedText.
	nbAntsView text:
		self getTMASimulationExperimentalServicesProvider getAnts size
			asRopedText.
	nbInsectsView text:
		self getTMASimulationExperimentalServicesProvider getInsects size
			asRopedText.
	storageView text:
		self getTMASimulationExperimentalServicesProvider getStorage
			asRopedText
]

{ #category : #'events - lifecycle' }
MAGroundExperimental >> updateView [
	
	self doSimulationStep

	
]
