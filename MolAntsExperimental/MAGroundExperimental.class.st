Class {
	#name : #MAGroundExperimental,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundExperimentalType + TMASimulationExperimentalToGlobalEvents + TMATimeTravelExperimentalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait + TMATimeTravelExperimentalEvents classTrait',
	#instVars : [
		'viewLoop',
		'mySpace',
		'refreshing',
		'stepView',
		'nbAntsView',
		'nbInsectsView',
		'returningStepView',
		'storageView',
		'labelText',
		'label',
		'buttonStartTimeTravel',
		'buttonStopTimeTravel',
		'buttonOneStepBefore',
		'buttonOneStepAfter',
		'buttonPlayBackward',
		'buttonReplay',
		'buttonPlay',
		'buttonPause'
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

	self
		forServices: TMATimeTravelExperimentalServices
		useProvider: #TimeTravel.

	mySpace := self openInNewSpace extent:
		           MASimulationManagerExperimental simulationWidth
		           @
		           (MASimulationManagerExperimental simulationHeight + 500).

	self createInfoPanel.
	self startViewLoop
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

	mySpace ifNotNil: [ mySpace close ].
	self stopViewLoop
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
	buttonPause := BlElement new
		               background: Color orange;
		               geometry:
			               (BlRoundedRectangleGeometry cornerRadius: 2);
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
			               @ 10;
		               addEventHandler: (BlEventHandler
				                on: BlClickEvent
				                do: [ :anEvent | 
					                buttonPause isVisible ifTrue: [ 
							                self isRunning ifTrue: [ 
									                self isRestoring ifFalse: [ 
											                MASimulationManagerExperimental
												                pauseSimulation ] ] ].
					                anEvent consumed: true ]).
	labelText := 'Pause' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonPause addChild: label.
	infoPanel addChild: buttonPause.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding Play button"
	buttonPlay := BlElement new
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
					               buttonPlay isVisible ifTrue: [ 
							               self isRunning ifFalse: [ 
									               self isRestoring ifFalse: [ 
											               MASimulationManagerExperimental
												               playSimulation ] ] ].
					               anEvent consumed: true ]).
	labelText := 'Play' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonPlay addChild: label.
	infoPanel addChild: buttonPlay.

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
	"Adding steps to the panel."
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
	"Adding the number of insects to the panel."
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
	"Adding the number of ants to the panel."
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
	"Adding storage to the panel."
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
	"Adding returningStep to the panel."
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
	buttonStartTimeTravel := BlElement new
		                         background: Color white;
		                         geometry:
			                         (BlRoundedRectangleGeometry cornerRadius:
					                          2);
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
			                         MASimulationManagerExperimental
				                         simulationWidth / 10 @ 80;
		                         addEventHandler: (BlEventHandler
				                          on: BlClickEvent
				                          do: [ :anEvent | 
					                          buttonStartTimeTravel isVisible 
						                          ifTrue: [ 
							                          self isRunning
								                          ifTrue: [ 
									                          self isRestoring ifFalse: [ 
											                          self
												                          getTMATimeTravelExperimentalServicesProvider
												                          startTimeTravel.
											                          self updateView ] ]
								                          ifFalse: [ 
									                          self isRestoring ifFalse: [ 
											                          MASimulationManagerExperimental
												                          playSimulation.
											                          self
												                          getTMATimeTravelExperimentalServicesProvider
												                          startTimeTravel.
											                          self updateView ] ] ].
					                          anEvent consumed: true ]).
	labelText := 'Start time travel' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonStartTimeTravel addChild: label.
	timeTravelPanel addChild: buttonStartTimeTravel.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding the Stop time trave button"
	buttonStopTimeTravel := BlElement new
		                        background: Color white;
		                        geometry:
			                        (BlRoundedRectangleGeometry cornerRadius: 2);
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
			                        MASimulationManagerExperimental
				                        simulationWidth / 10 * 3 @ 80;
		                        addEventHandler: (BlEventHandler
				                         on: BlClickEvent
				                         do: [ :anEvent | 
					                         buttonStopTimeTravel isVisible ifTrue: [ 
							                         self isRunning ifFalse: [ 
									                         self isRestoring ifTrue: [ 
											                         self
												                         getTMATimeTravelExperimentalServicesProvider
												                         stopTimeTravel.
											                         self updateView ] ] ].
					                         anEvent consumed: true ]).
	labelText := 'Stop time travel' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonStopTimeTravel addChild: label.
	timeTravelPanel addChild: buttonStopTimeTravel.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding One Step before button"
	buttonOneStepBefore := BlElement new
		                       background: Color white;
		                       geometry:
			                       (BlRoundedRectangleGeometry cornerRadius: 2);
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
			                       MASimulationManagerExperimental
				                       simulationWidth / 10 * 5 @ 80;
		                       addEventHandler: (BlEventHandler
				                        on: BlClickEvent
				                        do: [ :anEvent | 
					                        buttonOneStepBefore isVisible ifTrue: [ 
							                        self
								                        getTMATimeTravelExperimentalServicesProvider
								                        restoreOneStepBefore.
							                        self updateView ].
					                        anEvent consumed: true ]).
	labelText := 'One step before' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonOneStepBefore addChild: label.
	timeTravelPanel addChild: buttonOneStepBefore.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding One Step after button"
	buttonOneStepAfter := BlElement new
		                      background: Color white;
		                      geometry:
			                      (BlRoundedRectangleGeometry cornerRadius: 2);
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
			                      MASimulationManagerExperimental
				                      simulationWidth / 10 * 7 @ 80;
		                      addEventHandler: (BlEventHandler
				                       on: BlClickEvent
				                       do: [ :anEvent | 
					                       buttonOneStepAfter isVisible ifTrue: [ 
							                       self
								                       getTMATimeTravelExperimentalServicesProvider
								                       restoreOneStepAfter.
							                       self updateView ].
					                       anEvent consumed: true ]).
	labelText := 'One step after' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonOneStepAfter addChild: label.
	timeTravelPanel addChild: buttonOneStepAfter.


	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding playing backward button"
	buttonPlayBackward := BlElement new
		                      background: Color white;
		                      geometry:
			                      (BlRoundedRectangleGeometry cornerRadius: 2);
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
			                      MASimulationManagerExperimental
				                      simulationWidth / 10 * 3 @ 130;
		                      addEventHandler: (BlEventHandler
				                       on: BlClickEvent
				                       do: [ :anEvent | 
					                       buttonPlayBackward isVisible ifTrue: [ 
							                       self
								                       getTMATimeTravelExperimentalServicesProvider
								                       playBackward.
							                       self updateView ].
					                       anEvent consumed: true ]).
	labelText := 'Play Backward' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonPlayBackward addChild: label.
	timeTravelPanel addChild: buttonPlayBackward.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding replay button"
	buttonReplay := BlElement new
		                background: Color white;
		                geometry:
			                (BlRoundedRectangleGeometry cornerRadius: 2);
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
			                MASimulationManagerExperimental simulationWidth
			                / 10 * 5 @ 130;
		                addEventHandler: (BlEventHandler
				                 on: BlClickEvent
				                 do: [ :anEvent | 
					                 buttonReplay isVisible ifTrue: [ 
							                 self
								                 getTMATimeTravelExperimentalServicesProvider
								                 replay.
							                 self updateView ].
					                 anEvent consumed: true ]).
	labelText := 'Relay' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonReplay addChild: label.
	timeTravelPanel addChild: buttonReplay
]

{ #category : #initialization }
MAGroundExperimental >> drawOnSpartaCanvas: aCanvas [

	"Re writing this method here, in order to directly draw inside the canvas all the elements of the system. Tihs permit to keep good performances even if there is a lot of elements to draw."

	super drawOnSpartaCanvas: aCanvas.


	aCanvas figure
		path: (Rectangle
				 origin: MASimulationManagerExperimental  simulationAntHillPosition - (20 @ 20)
				 extent: 40 @ 40);
		background: Color white;
		draw.

	self getTMASimulationExperimentalServicesProvider ants ifNotNil: [ 
		self getTMASimulationExperimentalServicesProvider ants do: [ :ant | 
			aCanvas figure
				path: (aCanvas shape circleAt: ant position radius: 5);
				background: Color orange;
				backgroundAlpha: 1;
				draw ] ].

	self getTMASimulationExperimentalServicesProvider insects ifNotNil: [ 
		self getTMASimulationExperimentalServicesProvider insects 
			keysAndValuesDo: [ :position :insects | 
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

{ #category : #'life cycle' }
MAGroundExperimental >> initialize [

	"Initialization of the ground"

	super initialize.
	self size: MASimulationManagerExperimental simulationWidth
		@ MASimulationManagerExperimental  simulationHeight.
	self background: (Color fromHexString: 'c7baae')
]

{ #category : #initialization }
MAGroundExperimental >> isPlayingBackward [ 

	^ self getTMATimeTravelExperimentalServicesProvider isPlayingBackward
]

{ #category : #initialization }
MAGroundExperimental >> isReplaying [

	^ self getTMATimeTravelExperimentalServicesProvider isReplaying
]

{ #category : #initialization }
MAGroundExperimental >> isRestoring [

	^ self getTMATimeTravelExperimentalServicesProvider isRestoring
]

{ #category : #initialization }
MAGroundExperimental >> isRunning [

	^ self getTMASimulationExperimentalServicesProvider isRunning
]

{ #category : #'events - lifecycle' }
MAGroundExperimental >> startViewLoop [
	"Starting the view loop."
	viewLoop := [ 
	            [ true ] whileTrue: [ 
		            self updateView.
		            (Delay forMilliseconds:
			             MASimulationManagerExperimental
				             simulationStepDurationInMs) wait ] ] forkAt:
		            Processor userBackgroundPriority.
	viewLoop name: 'Molecule ViewLoop Process'.
	viewLoop resume
]

{ #category : #'events - lifecycle' }
MAGroundExperimental >> stopViewLoop [

	viewLoop ifNil: [ ^ self ].
	viewLoop terminate.
	viewLoop := nil
]

{ #category : #initialization }
MAGroundExperimental >> updateInfoPanel [

	"Modify each elements of the info panel. It permit to keep the view up to date with the simulation."

	stepView text:
		self getTMASimulationExperimentalServicesProvider step asRopedText.
	nbAntsView text:
		self getTMASimulationExperimentalServicesProvider ants size
			asRopedText.
	nbInsectsView text:
		self getTMASimulationExperimentalServicesProvider insects size
			asRopedText.
	storageView text:
		self getTMASimulationExperimentalServicesProvider storage
			asRopedText.

	self isRunning
		ifTrue: [ 
			buttonPlay background: Color gray.
			buttonPause background: Color orange ]
		ifFalse: [ 
			buttonPause background: Color gray.
			self isRestoring ifTrue:[buttonPlay background: Color gray.] ifFalse: [ buttonPlay background: Color green. ].
			 ]
]

{ #category : #initialization }
MAGroundExperimental >> updateTimeTravelPanel [

	"Modify each elements of the time travel panel. It permit to keep the view up to date with the simulation."

	returningStepView text:
		self getTMATimeTravelExperimentalServicesProvider restoringStep
			asRopedText.
			
		self isRestoring
		ifTrue: [ 
			buttonStartTimeTravel background: Color gray.
			buttonStopTimeTravel background: Color white.
			buttonOneStepBefore background: Color white.
			buttonOneStepAfter background: Color white.
			buttonPlayBackward background: Color white.
			buttonReplay background: Color white.
			self isPlayingBackward ifTrue: [ 
				buttonOneStepBefore background: Color gray.
				buttonOneStepAfter background: Color gray.
				buttonReplay background: Color gray ].
			self isReplaying ifTrue: [ 
				buttonOneStepBefore background: Color gray.
				buttonOneStepAfter background: Color gray.
				buttonPlayBackward background: Color gray ] ]
		ifFalse: [ 
			buttonStartTimeTravel background: Color white.
			buttonStopTimeTravel background: Color gray.
			buttonOneStepBefore background: Color gray.
			buttonOneStepAfter background: Color gray.
			buttonPlayBackward background: Color gray.
			buttonReplay background: Color gray ]
]

{ #category : #'life cycle' }
MAGroundExperimental >> updateView [

	self updateInfoPanel.
	self updateTimeTravelPanel
]
