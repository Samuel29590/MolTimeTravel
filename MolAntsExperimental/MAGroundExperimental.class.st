Class {
	#name : #MAGroundExperimental,
	#superclass : #BlElement,
	#traits : 'MolComponentImpl + TMAGroundExperimentalType + TMASimulationExperimentalToGlobalEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAGroundExperimentalType classTrait + TMASimulationExperimentalToGlobalEvents classTrait',
	#instVars : [
		'mySpace',
		'refreshing',
		'stepView',
		'nbAntsView',
		'nbInsectsView'
	],
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MAGroundExperimental >> componentActivate [

	"Activation of the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber  subscribe: self
]

{ #category : #'life cycle' }
MAGroundExperimental >> componentInitialize [

	"Initialization of the MAGround component."

	mySpace := self openInNewSpace extent:
		           MASimulationManagerExperimental simulationWidth
		           @
		           (MASimulationManagerExperimental simulationHeight + 350).

	self createInfoPanel
]

{ #category : #'life cycle' }
MAGroundExperimental >> componentPassivate [

	"Passivating the MAGround component."

	self getTMASimulationExperimentalToGlobalEventsSubscriber unsubscribe: self
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

	| infoPanel timeTravelPanel button |
	timeTravelPanel := BlElement new.
	timeTravelPanel background: Color black.
	timeTravelPanel relocate:
		0 @ MASimulationManagerExperimental simulationHeight.
	timeTravelPanel size:
		MASimulationManagerExperimental simulationWidth @ 300.
	timeTravelPanel constraintsDo: [ :c | 
		c maxHeight: 50.
		c maxWidth: MASimulationManagerExperimental simulationWidth ].
	mySpace addChild: timeTravelPanel.

	"Adding One Step before button"
	button := BlElement new.
	button background: Color white.
	button size: 120 @ 25.
	button relocate:
		MASimulationManagerExperimental simulationWidth / 10 * 2 @ 10.
	button addChild: ((BlTextElement new relocate: 5 @ 5) text:
			 'One step before' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ "Action to write here !" ].
				 anEvent consumed: true ]).
	timeTravelPanel addChild: button.

	"Adding One Step after button"
	button := BlElement new.
	button background: Color white.
	button size: 120 @ 25.
	button relocate:
		MASimulationManagerExperimental simulationWidth / 10 * 6 @ 10.
	button addChild: ((BlTextElement new relocate: 5 @ 5) text:
			 'One step after' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ "Action to write here !" ].
				 anEvent consumed: true ]).
	timeTravelPanel addChild: button.



	infoPanel := BlElement new.
	infoPanel background: Color lightGray.
	infoPanel relocate:
		0 @ (MASimulationManagerExperimental simulationHeight + 50).
	infoPanel size: MASimulationManagerExperimental simulationWidth @ 300.
	infoPanel constraintsDo: [ :c | 
		c maxHeight: 300.
		c maxWidth: MASimulationManagerExperimental simulationWidth ].
	mySpace addChild: infoPanel.


	"Adding Pause button"
	button := BlElement new.
	button background: Color orange.
	button size: 100 @ 25.
	button relocate:
		MASimulationManagerExperimental simulationWidth / 10 @ 10.
	button addChild:
		((BlTextElement new relocate: 30 @ 5) text: 'Pause' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ 
					 self isRunning ifTrue: [ 
						 MASimulationManagerExperimental pauseSimulation ] ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.

	"Adding Play button"
	button := BlElement new.
	button background: Color green.
	button size: 100 @ 25.
	button relocate:
		MASimulationManagerExperimental simulationWidth / 10 * 4 @ 10.
	button addChild:
		((BlTextElement new relocate: 35 @ 5) text: 'Play' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ 
					 self isRunning ifFalse: [ 
						 MASimulationManagerExperimental playSimulation ] ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.

	"Adding Stop button"
	button := BlElement new.
	button background: Color red.
	button size: 100 @ 25.
	button relocate:
		MASimulationManagerExperimental simulationWidth / 10 * 7 @ 10.
	button addChild:
		((BlTextElement new relocate: 35 @ 5) text: 'Stop' asRopedText).
	button addEventHandler: (BlEventHandler
			 on: BlClickEvent
			 do: [ :anEvent | 
				 button isVisible ifTrue: [ 
					 MASimulationManagerExperimental stopSimulation ].
				 anEvent consumed: true ]).
	infoPanel addChild: button.

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


	"Ajout du nombre de proies à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 @ 130;
			  background: Color transparent) text:
			 'Number of insects :' asRopedText).
	nbInsectsView := BlTextElement new
		                 relocate:
			                 MASimulationManagerExperimental simulationWidth
			                 / 10 @ 150;
		                 background: Color transparent;
		                 text: '000' asRopedText.
	infoPanel addChild: nbInsectsView.

	"Ajout du nombre de fourmis à l'interface."
	infoPanel addChild: ((BlTextElement new
			  relocate:
				  MASimulationManagerExperimental simulationWidth / 10 * 5 @ 80;
			  background: Color transparent) text:
			 'Number of ants :' asRopedText).
	nbAntsView := BlTextElement new
		              relocate:
			              MASimulationManagerExperimental simulationWidth / 10
			              * 5 + 100 @ 100;
		              background: Color transparent;
		              text: '000' asRopedText.
	infoPanel addChild: nbAntsView
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
			self getTMASimulationExperimentalServicesProvider getInsects do: [ 
				:insect | 
				aCanvas figure
					path: (aCanvas shape circleAt: insect position radius: 5);
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

{ #category : #initialization }
MAGroundExperimental >> isRunning [

	^ self getTMASimulationExperimentalServicesProvider isRunning
]

{ #category : #'events - lifecycle' }
MAGroundExperimental >> simulationStepSent [

	self doSimulationStep.
]

{ #category : #initialization }
MAGroundExperimental >> updateInfoPanel [

	"Modify each elements of the info panel. It permit to keep the view up to date with the simulation."

	stepView text:
		self getTMASimulationExperimentalServicesProvider getStep
			asRopedText.
	nbAntsView text:
		self getTMASimulationExperimentalServicesProvider getAnts size
			asRopedText.
		nbInsectsView text: self getTMASimulationExperimentalServicesProvider getInsects size asRopedText.			
]
