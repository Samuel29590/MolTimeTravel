"
The actual implementation of the *TMASimulationManagerType*: *MASimulationManager*, describe the manager of the MolAnts's system. It aims to put in relation every entity of the system. The simulation manager reference all the entities of the system in ordered collections or dictionaries and can access to all the entities and send them events. This feature permits to do concrete actions as interaction between ants and insects or ants and pheromones.

Futhermore, the simulation manager contains the main loop of the system. This loop send the *simulationStepSend* event message to each entity at each turn.

The simulation manager also implement methods to manage ants and insects (create, update and remove).

Finally this implementation provides *start / pause / play / stop* methods on the class side. Also on the side class the simulation manager provides the simulation data as step duration, width and height of the ground, and ant hill position.

***Variables :***
 
 -*simulationThread*, containing the thread that sends at every step the event: * simulationStepSend*.
 
 -*step*, is an integer that count the number of step.
 
 -*isAntHillCreated*, is a Boolean that is put to true at the creation of the first ant and put to false when ants are removed.
 
 -*ants*, is an ordered collection of ants. It contains all ants of the system. It is used to draw them on the ground and update the info panel.
 
 -*nbAnt*, is an integer incremented at each ant creation. It is used to set the name of each ant component instance.
 
 -*insectsPos*, is a dictionary containing all the insects of the simulation and their position. Key: a point. Value: an ordered collection of insects.
 
 -*nbDelivered*, is an integer that count the number of insect delivered to the anthill.
 
 -*feedingPointsPos*, is a dictionary containing all the feeding points of the simulation and their position. Key: a point. Value: an ordered collection of feeding points.
"
Class {
	#name : #MASimulationManager,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerType + TMASimulationServices + TMARoleEvents + TMAInsectEvents + TMAStageEvents + TMATimeTravelEvents',
	#classTraits : 'TMASimulationManagerType classTrait + TMASimulationServices classTrait + TMARoleEvents classTrait + TMAInsectEvents classTrait + TMAStageEvents classTrait + TMATimeTravelEvents classTrait',
	#instVars : [
		'simulationThread',
		'step',
		'ants',
		'nbAnts',
		'insects',
		'storage',
		'feedingPoints'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #scripts }
MASimulationManager class >> pauseSimulation [
	<script>
	
	self passivate
]

{ #category : #scripts }
MASimulationManager class >> playSimulation [
	<script>
	
	self activate.
]

{ #category : #properties }
MASimulationManager class >> simulationAntHillPosition [

	^ 400 @ 250
]

{ #category : #properties }
MASimulationManager class >> simulationHeight [

	^ 500
]

{ #category : #properties }
MASimulationManager class >> simulationStepDurationInMs [

	^ 30
]

{ #category : #properties }
MASimulationManager class >> simulationWidth [

	" Minimum recommended : 500 for a clear UI"

	^ 800
]

{ #category : #scripts }
MASimulationManager class >> startSimulation [

	<script>
	self start.
]

{ #category : #scripts }
MASimulationManager class >> startSimulationWithTimeTravel [

	<script>
	MATimeTravel start.
	self start.
]

{ #category : #scripts }
MASimulationManager class >> stopSimulation [
	<script>
	
	self stop.
	MolComponentManager cleanUp.
	
]

{ #category : #events }
MASimulationManager >> ant: anAnt killAt: aPoint [

	| insect |
	"Removing the insect in the dictionary."
	(insects includesKey: aPoint) ifTrue: [ 
		insect := (insects at: aPoint) removeFirst.
		(insects at: aPoint) isEmpty ifTrue: [ 
			insects removeKey: aPoint ] ].

	"Stoping the insect's component instance."
	MAInsect stop: insect componentName
]

{ #category : #'component life cycle' }
MASimulationManager >> componentActivate [

	"Activation of the MASimulationManager component."

	super componentActivate.
	self getTMAStageEventsSubscriber subscribe: self.
	self getTMARoleEventsSubscriber subscribe: self.
	self getTMAInsectEventsSubscriber subscribe: self.
	
	"--------------------------Time Travel--------------------------"
	"Subscription to the Time Travel event"
	self getTMATimeTravelEventsSubscriber subscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'component life cycle' }
MASimulationManager >> componentInitialize [

	"--------------------------Time Travel--------------------------"
	"Connection to the TimeTravel service."
	self forServices: TMATimeTravelServices useProvider: #default.
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component notifies its creation" 
			self getTMATimeTravelServicesProvider creationOf: self ] ].
	"---------------------------------------------------------------"
	
	self getTMATimeTravelEventsSubscriber subscribe: self.
	"Initialization of the MASimulationManager component."

	super componentInitialize.

	self start.
	
	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component saves its state."
			self saveForTimeTravel ] ].
	"---------------------------------------------------------------"
]

{ #category : #'component life cycle' }
MASimulationManager >> componentPassivate [

	"Passivating the MASimulationManager component."

	super componentPassivate.

	self getTMAStageEventsSubscriber unsubscribe: self.
	self getTMARoleEventsSubscriber unsubscribe: self.
	self getTMAInsectEventsSubscriber unsubscribe: self.

	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTMATimeTravelEventsSubscriber unsubscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'component life cycle' }
MASimulationManager >> componentRemove [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTMATimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"
	
	"Removing the MASimulationManager component."
	
	self stop
]

{ #category : #private }
MASimulationManager >> createAnt [

	"Creation of a new ant"

	| name ant |
		nbAnts := nbAnts + 1.
		name := ('Ant' , nbAnts printString) asSymbol.
		ant := MAAnt start: name.

		"Adding event producer into SimulationManager"

		self forEvents: TMARoleEvents addProducer: ant getRole componentName.

		"Adding the ant to the OrderedCollection of ants"

		ants add: ant 
]

{ #category : #private }
MASimulationManager >> createFeedingPoints [

	"Creation of the 5 first feeding points"

	1 to: 5 do: [ :e | 
		| feed name newPos |
		name := ('Feed' , e printString) asSymbol.
		feed := MAFeedingPoint start: name.
		newPos := feed getPosition.

		"Add the insect to the dictionary of insects positions."
		(feedingPoints includesKey: newPos)
			ifFalse: [ 
				| collection |
				collection := OrderedCollection new.
				collection add: feed.
				feedingPoints add: newPos -> collection ]
			ifTrue: [ (feedingPoints at: newPos) addLast: feed ] ]
]

{ #category : #private }
MASimulationManager >> createInsects [

	"Creation of the 50 firt insects"

	1 to: 50 do: [ :e | 
		| insect name pos |
		name := ('Insect' , e printString) asSymbol.
		insect := MAInsect start: name.
		pos := insect getPosition.
		
		"Adding events producer into SimulationMManager"
		self forEvents: TMAInsectEvents addProducer: name.

		"Add the insect to the dictionary of insects positions."
		(insects includesKey: pos)
			ifFalse: [ 
				| collection |
				collection := OrderedCollection new.
				collection add: insect.
				insects add: pos -> collection ]
			ifTrue: [ (insects at: pos) addLast: insect ] ]
]

{ #category : #services }
MASimulationManager >> getAnts [

	"Returning an OrderedCollection of all the ant currently alive in the system."

	^ ants
]

{ #category : #services }
MASimulationManager >> getFeedingPoints [

	"Returning a Dictionary of the feeding point positions (key: a Point / value: an OrderedCollection of MAFeedingPoint instances"

	^ feedingPoints
]

{ #category : #services }
MASimulationManager >> getInsects [

	"Returning a Dictionary of the insects positions (key: a Point / value: an OrderedCollection of MAInsect instances"

	^ insects
]

{ #category : #services }
MASimulationManager >> getPheromonesDict [

	"Returning a Dictionary of all pheromone of exploration in the system (key: position / value: (the ant that create it -> intensity))"

	^ self getTMAPheromoneServicesProvider getPheromonesDict
]

{ #category : #services }
MASimulationManager >> getPheromonesReturnDict [

	"Returning a Dictionary of all pheromone of return in the system (key: position / value: (the ant that create it -> intensity))"

	^ self getTMAPheromoneServicesProvider getPheromonesReturnDict
]

{ #category : #services }
MASimulationManager >> getStep [

	^step
]

{ #category : #services }
MASimulationManager >> getStorage [

	"Returning the number of insects delivered to the ant hill."

	^ storage
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAFeedingPointServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMAFeedingPointServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMAFeedingPointServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAInsectEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAInsectEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAInsectEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAPheromoneServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMAPheromoneServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMAPheromoneServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MASimulationManager >> getTMARoleEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMARoleEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMARoleEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMASimulationToGlobalEventsNotifier [
	^self eventsNotifiers at: TMASimulationToGlobalEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationToGlobalEvents name: nil].
]

{ #category : #'component accessing' }
MASimulationManager >> getTMAStageEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAStageEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAStageEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManager >> getTMATimeTravelEventsSubscriber [
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
MASimulationManager >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #events }
MASimulationManager >> insectDelivered [

	storage := storage + 1.
]

{ #category : #services }
MASimulationManager >> isRunning [

	^ isRunning ifNil: [ isRunning := false ].
]

{ #category : #events }
MASimulationManager >> positionChangedFor: anInsect oldPos: aPoint newPos: anotherPoint [

	"Add or update the insect position in the dictionary."

	"remove the old position."

	(insects includesKey: aPoint) ifTrue: [ 
		(insects at: aPoint) remove: anInsect ifAbsent: [  ].
		(insects at: aPoint) isEmpty ifTrue: [ 
			insects removeKey: aPoint ] ].

	"Add to the new position."
	(insects includesKey: anotherPoint)
		ifFalse: [ 
			| collection |
			collection := OrderedCollection new.
			collection add: anInsect.
			insects add: anotherPoint -> collection ]
		ifTrue: [ (insects at: anotherPoint) addLast: anInsect ]
]

{ #category : #events }
MASimulationManager >> queenLaid [

	"Creation of a new ant."

	self createAnt
]

{ #category : #private }
MASimulationManager >> removeAnts [

	"Delete nbAnt ants"

	ants do: [ :e | 
		MAAnt stop: e componentName.].
	ants := nil.
	nbAnts := 0
]

{ #category : #private }
MASimulationManager >> removeFeedingPoints [

	"Delete feeding points"

	feedingPoints do: [ :each | 
		| name |
		each do: [ :feedingPoint | "Delete a feeding point"
			name := feedingPoint componentName.
			MAFeedingPoint stop: name ] ].
	feedingPoints := nil
]

{ #category : #private }
MASimulationManager >> removeInsects [

	"Delete insects"

	insects do: [ :each | 
		| name |
		each do: [ :insect | "Delete insect"
			name := insect componentName.
			MAInsect stop: name ] ].
	insects := nil
]

{ #category : #private }
MASimulationManager >> removePheromones [

	"delete all pheromones of the system."

	MAPheromones stop: #Pheromones
]

{ #category : #events }
MASimulationManager >> restoreFrom: aMemento [

	| dict orderedCollection |
	componentName := aMemento componentName.
		step := aMemento getStep.
	storage := aMemento getStorage.

	aMemento getInsects isDictionary ifTrue: [ 
		dict := Dictionary new.
		aMemento getInsects keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | 
				list add: (MolUtils instanceOf: value key named: value value) ].
			dict add: k -> list ] ].
	insects := dict.

	aMemento getFeedingPoints isDictionary ifTrue: [ 
		dict := Dictionary new.
		aMemento getFeedingPoints keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | 
				list add: (MolUtils instanceOf: value key named: value value) ].
			dict add: k -> list ] ].
	feedingPoints := dict.

	orderedCollection := OrderedCollection new.
	aMemento getAnts isCollection ifTrue: [ 
		aMemento getAnts do: [ :value | 
			orderedCollection add:
				(MolUtils instanceOf: value key named: value value) ] ].
	ants := orderedCollection
]

{ #category : #events }
MASimulationManager >> saveForTimeTravel [

		| memento |
	memento := MASimulationMemento new.

	self getTMATimeTravelServicesProvider
		save: (memento save: self).
]

{ #category : #events }
MASimulationManager >> stageChanged: aSymbol for: anAnt [

	"Removing an ant"

	aSymbol = #dead ifTrue: [ ants remove: anAnt ]
]

{ #category : #services }
MASimulationManager >> start [

	| pheromones ground memento |
	memento := MASimulationMemento new.

	self forServices: TMATimeTravelServices useProvider: #default.
	self forEvents: TMATimeTravelEvents addProducer: #default.

	isRunning := false.
	simulationThread := nil.
	step := 0.
	ants := OrderedCollection new.
	nbAnts := 0.
	storage := 0.
	insects := Dictionary new.
	feedingPoints := Dictionary new.
	pheromones := MAPheromones start: #Pheromones.
	self
		forServices: TMAPheromoneServices
		useProvider: pheromones componentName asSymbol.
	ground := MAGround start: #Ground.
	ground
		forServices: TMAPheromoneServices
		useProvider: pheromones componentName asSymbol.

	self createAnt.
	self createInsects.
	self createFeedingPoints.
	self startSimulationLoop.
	self getTMASimulationToGlobalEventsNotifier started
]

{ #category : #private }
MASimulationManager >> startSimulationLoop [

	simulationThread ifNil: [ 
		simulationThread := [ 
		                    [ true ] whileTrue: [ 
			                    isRunning ifTrue: [ 
				                    | doSimulationStep |
				                    doSimulationStep := true.
				                    (MolUtils
					                     instanceOf: MATimeTravel
					                     named: #default) ifNotNil: [ 
					                    self getTMATimeTravelServicesProvider
						                    isRestoring ifTrue: [ 
						                    doSimulationStep := false ] ].

				                    doSimulationStep ifTrue: [ 
					                    | memento |
					                    memento := MASimulationMemento new.
					                    step := step + 1.
					                    self getTMASimulationToGlobalEventsNotifier 
						                    simulationStepSent: step.

					                    self getTMATimeTravelServicesProvider
						                    saveTheApplication.

					                    (Delay forMilliseconds:
						                     self class simulationStepDurationInMs) wait ] ] ] ]
			                    newProcess priority:
			                    Processor userBackgroundPriority.
		simulationThread name: 'Molecule SimulationManager Process' ].
	simulationThread resume
]

{ #category : #events }
MASimulationManager >> startTimeTravel [

	isRunning := false
]

{ #category : #services }
MASimulationManager >> stop [

	self stopSimulationLoop.
	MAGround stop: #Ground.
	self removeAnts.
	self removeInsects.
	self removeFeedingPoints.
	self removePheromones.
	isRunning := false.
	self getTMASimulationToGlobalEventsNotifier stopped.
	
	
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
	MATimeTravel stop].
]

{ #category : #private }
MASimulationManager >> stopSimulationLoop [

	simulationThread ifNil: [ ^ self ].
	simulationThread terminate.
	simulationThread := nil
]

{ #category : #events }
MASimulationManager >> stopTimeTravel [

	isRunning := true
]

{ #category : #events }
MASimulationManager >> worker: anAnt eatAt: aPoint [

	"Deacreasing the capacity of the feedingPoint."

	(feedingPoints includesKey: aPoint) ifTrue: [ 
		(feedingPoints at: aPoint) first eated = 0 ifTrue: [ 
			| feedingPoint |
			feedingPoint := (feedingPoints at: aPoint) removeFirst.
			(feedingPoints at: aPoint) isEmpty ifTrue: [ 
				feedingPoints removeKey: aPoint ].
			MAFeedingPoint stop: feedingPoint componentName ] ]
]

{ #category : #events }
MASimulationManager >> workerExploringPositionChanged: aPoint for: anAnt [

	"Creation or update of a new pheromone of exploration."

	self getTMASimulationToGlobalEventsNotifier
		pheromoneNew: aPoint
		for: anAnt
]

{ #category : #events }
MASimulationManager >> workerReturningPositionChanged: aPoint for: anAnt [

	"Creation or update of a new pheromone of return."

	self getTMASimulationToGlobalEventsNotifier
		pheromoneReturnNew: aPoint
		for: anAnt
]
