Class {
	#name : #MASimulationManagerExperimental,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerExperimentalType + TMASimulationExperimentalServices + TMATimeTravelExperimentalEvents + TMAInsectsEvents + TMAAntsEvents',
	#classTraits : 'TMASimulationManagerExperimentalType classTrait + TMASimulationExperimentalServices classTrait + TMATimeTravelExperimentalEvents classTrait + TMAInsectsEvents classTrait + TMAAntsEvents classTrait',
	#instVars : [
		'simulationThread',
		'step',
		'restoringStep',
		'insects',
		'nbInsects',
		'ants',
		'nbAnts',
		'storage',
		'isRunning',
		'isRestoring'
	],
	#category : #MolAntsExperimental
}

{ #category : #properties }
MASimulationManagerExperimental class >> pauseSimulation [

	<script>
	self passivate
]

{ #category : #properties }
MASimulationManagerExperimental class >> playSimulation [

	<script>
	self activate
]

{ #category : #properties }
MASimulationManagerExperimental class >> simulationAntHillPosition [

	^ 400 @ 250
]

{ #category : #properties }
MASimulationManagerExperimental class >> simulationHeight [

	^ 500
]

{ #category : #properties }
MASimulationManagerExperimental class >> simulationStepDurationInMs [

	^ 100
]

{ #category : #properties }
MASimulationManagerExperimental class >> simulationWidth [

	" Minimum recommended : 500 for a clear UI"

	^ 800
]

{ #category : #properties }
MASimulationManagerExperimental class >> startSimulation [

	<script>
	self start.
	self passivate
]

{ #category : #properties }
MASimulationManagerExperimental class >> stopSimulation [

	<script>
	self stop.
	MolComponentManager cleanUp
]

{ #category : #accessing }
MASimulationManagerExperimental >> ant: anAnt eatAt: aPoint [

	| insect |
	
	"Removing the insect in the dictionary."
	"(insects includesKey: aPoint) ifTrue: [ 
		insect := (insects at: aPoint) removeFirst.
		(insects at: aPoint) isEmpty ifTrue: [ insects removeKey: aPoint ] ]."

	"Stoping the insect's component instance."
"	MAInsectExperimental stop: insect componentName.
"
	storage := storage + 1
]

{ #category : #services }
MASimulationManagerExperimental >> ants [

	^ ants
]

{ #category : #accessing }
MASimulationManagerExperimental >> ants: anObject [

	ants := anObject
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> componentActivate [

	"Activation of the MASimulationManager component."

	super componentActivate.
	isRunning := true.

	self getTMAAntsEventsSubscriber subscribe: self.
	self getTMAInsectsEventsSubscriber subscribe: self.
	self getTMATimeTravelExperimentalEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> componentInitialize [

	"Initialization of the MASimulationManager component."

	super componentInitialize.
	self start
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> componentPassivate [

	"Passivating the MASimulationManager component."

	super componentPassivate.
	isRunning := false.

	self getTMAAntsEventsSubscriber unsubscribe: self.
	self getTMAInsectsEventsSubscriber unsubscribe: self.
	self getTMATimeTravelExperimentalEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> componentRemove [

	"Removing the MASimulationManager component."

	super componentRemove.
	self stop
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> createAnts [

	"Creation of a new ant"

	| name ant memento |
	
	1 to: 2 do: [ :e | 
		memento := MAAntMemento new.
		nbAnts := nbAnts + 1.
		name := ('Ant' , nbAnts printString) asSymbol.
		ant := MAAntExperimental start: name.
		ant position: self class simulationAntHillPosition.

		"Adding the ant to the OrderedCollection of ants"
		ants add: ant.

		"Adding events producer into SimulationMManager"
		self forEvents: TMAAntsEvents addProducer: name.

		ant
			forServices: TMASimulationExperimentalServices
			useProvider: self componentName.

		self getTMATimeTravelExperimentalServicesProvider
			save: (memento save: ant)
			at: step ]
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> createInsects [

	"Creation of a new insect"

	| name insect memento |
	1 to: 2 do: [ :e | 
	memento := MAInsectMemento new.
		nbInsects := nbInsects + 1.
		name := ('Insect' , nbInsects printString) asSymbol.
		insect := MAInsectExperimental start: name.
		insect position: 450 @ 200.
		"	insect position:
			(Random new nextIntegerBetween: 1 and: self class simulationWidth)
			@
			(Random new nextIntegerBetween: 1 and: self class simulationHeight).
"
		"Adding events producer into SimulationMManager"
		self forEvents: TMAInsectsEvents addProducer: name.

		"Adding the insect to the OrderedCollection of insects"
		self getTMATimeTravelExperimentalServicesProvider
			save: (memento save: insect)
			at: step.

		"adding the insect to the insects's dictionary"
		"Add the insect to the dictionary of insects positions."
		(insects includesKey: insect position)
			ifFalse: [ 
				| collection |
				collection := OrderedCollection new.
				collection add: insect.
				insects add: insect position -> collection ]
			ifTrue: [ (insects at: insect position) addLast: insect ] ]
]

{ #category : #services }
MASimulationManagerExperimental >> getAnts [

	^ants
]

{ #category : #services }
MASimulationManagerExperimental >> getInsects [

	^insects
]

{ #category : #services }
MASimulationManagerExperimental >> getReturningStep [

	^ restoringStep
]

{ #category : #services }
MASimulationManagerExperimental >> getStep [

	^step
]

{ #category : #services }
MASimulationManagerExperimental >> getStorage [

	^ storage
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> getTMAAntsEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAAntsEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAAntsEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> getTMAInsectsEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMAInsectsEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMAInsectsEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> getTMASimulationExperimentalToGlobalEventsNotifier [
	^self eventsNotifiers at: TMASimulationExperimentalToGlobalEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationExperimentalToGlobalEvents name: nil].
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> getTMATimeTravelExperimentalEventsSubscriber [
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
MASimulationManagerExperimental >> getTMATimeTravelExperimentalServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMATimeTravelExperimentalServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMATimeTravelExperimentalServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #services }
MASimulationManagerExperimental >> insects [
	^ insects
]

{ #category : #accessing }
MASimulationManagerExperimental >> insects: anObject [

	insects := anObject
]

{ #category : #services }
MASimulationManagerExperimental >> isRestoring [

	^ isRestoring
]

{ #category : #services }
MASimulationManagerExperimental >> isRunning [

	^ isRunning
]

{ #category : #accessing }
MASimulationManagerExperimental >> nbAnts [

	^ nbAnts
]

{ #category : #accessing }
MASimulationManagerExperimental >> nbAnts: anObject [

	nbAnts := anObject
]

{ #category : #accessing }
MASimulationManagerExperimental >> nbInsects [

	^ nbInsects
]

{ #category : #accessing }
MASimulationManagerExperimental >> nbInsects: anObject [

	nbInsects := anObject
]

{ #category : #events }
MASimulationManagerExperimental >> positionChangedFor: anInsect oldPos: aPoint newPos: anotherPoint [

	"Add or update the insect position in the dictionary."

	"remove the old position."

	(insects includesKey: aPoint) ifTrue: [ 
		(insects at: aPoint) remove: anInsect ifAbsent: [  ].
		(insects at: aPoint) isEmpty ifTrue: [ insects removeKey: aPoint ] ].

	"Add to the new position."
	(insects includesKey: anotherPoint)
		ifFalse: [ 
			| collection |
			collection := OrderedCollection new.
			collection add: anInsect.
			insects add: anotherPoint -> collection ]
		ifTrue: [ (insects at: anotherPoint) addLast: anInsect ]
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> removeAnts [

	"Delete nbAnt ants"

	ants do: [ :e | MAAntExperimental stop: e componentName ].
	ants := nil.
	nbAnts := 0
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> removeInsects [

	"Delete nbAnt ants"

	insects do: [ :each | 
		| name |
		each do: [ :insect | "Delete insect"
			name := insect componentName.
			MAInsectExperimental stop: name ] ].
	insects := nil.
	nbInsects := 0
]

{ #category : #events }
MASimulationManagerExperimental >> restore: aComponentName values: aMemento [

	self componentName = aComponentName ifTrue: [ 
			componentName := aMemento componentName.
	restoringStep := aMemento restoringStep.
	insects := aMemento insects.
	nbInsects := aMemento nbInsects.
	ants := aMemento ants.
	nbAnts := aMemento nbAnts.
	storage := aMemento storage ]
]

{ #category : #services }
MASimulationManagerExperimental >> restoreOneStepAfter [

	isRestoring ifTrue: [ 
	restoringStep < step ifTrue: [ 
		restoringStep := restoringStep + 1.
		self getTMATimeTravelExperimentalServicesProvider restoreAtStep:
			restoringStep.
		self getTMASimulationExperimentalToGlobalEventsNotifier updateView ]]
]

{ #category : #services }
MASimulationManagerExperimental >> restoreOneStepBefore [

	isRestoring ifTrue: [ 
		restoringStep > 0 ifTrue: [ 
			restoringStep := restoringStep - 1.
			self getTMATimeTravelExperimentalServicesProvider restoreAtStep:
				restoringStep.
			self getTMASimulationExperimentalToGlobalEventsNotifier updateView ] ]
]

{ #category : #services }
MASimulationManagerExperimental >> restoringStep [

	^ restoringStep
]

{ #category : #accessing }
MASimulationManagerExperimental >> restoringStep: anObject [

	restoringStep := anObject
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> start [

	| memento |
	memento := MASimulationMemento new.

	MATimeTravelExperimental start: 'TimeTravel'.
	self
		forServices: TMATimeTravelExperimentalServices
		useProvider: #TimeTravel.
	isRunning := true.
	isRestoring := false.
	simulationThread := nil.
	step := 0.
	restoringStep := 0.
	insects := Dictionary new.
	nbInsects := 0.
	ants := OrderedCollection new.
	nbAnts := 0.
	storage := 0.
	MAGroundExperimental start: 'Ground'.
	self createInsects.
	self createAnts.
	self getTMATimeTravelExperimentalServicesProvider save: (memento save: self) at: 0.
	self startSimulationLoop.
	self getTMASimulationExperimentalToGlobalEventsNotifier started
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> startSimulationLoop [

	simulationThread ifNil: [ 
		simulationThread := [ 
		                    [ true ] whileTrue: [ 
			                    isRunning ifTrue: [ 
				                    isRestoring
					                    ifTrue: [  ]
					                    ifFalse: [ 
						
													|memento|
													memento := MASimulationMemento new.
						                    step := step + 1.
						                    restoringStep := step.
						                    self
							                    getTMASimulationExperimentalToGlobalEventsNotifier 
							                    simulationStepSent: step.
						                    self
							                    getTMASimulationExperimentalToGlobalEventsNotifier
							                    updateView.
						                    self
							                    getTMATimeTravelExperimentalServicesProvider
							                    save: (memento 
									                     save: self)
							                    at: step.
						                    (Delay forMilliseconds:
							                     self class simulationStepDurationInMs)
							                    wait ] ] ] ] newProcess priority:
			                    Processor userBackgroundPriority.
		simulationThread name:
			'Molecule SimulationManagerExperimental Process' ].
	simulationThread resume
]

{ #category : #services }
MASimulationManagerExperimental >> startTimeTravel [

	isRunning := false.
	isRestoring := true.
	self getTMATimeTravelExperimentalServicesProvider startTimeTravel
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> stop [

	self stopSimulationLoop.
	MAGroundExperimental stop: 'Ground'.
	self removeAnts.
	self removeInsects.
	isRunning := false.
	self getTMASimulationExperimentalToGlobalEventsNotifier stopped.
	MATimeTravelExperimental stop: 'TimeTravel'.
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> stopSimulationLoop [

	simulationThread ifNil: [ ^ self ].
	simulationThread terminate.
	simulationThread := nil
]

{ #category : #services }
MASimulationManagerExperimental >> stopTimeTravel [
isRestoring ifTrue: [ 
		self getTMATimeTravelExperimentalServicesProvider restoreAtStep:
			step.
		self getTMATimeTravelExperimentalServicesProvider stopTimeTravel.
		isRestoring := false.
		isRunning := true ]
]

{ #category : #services }
MASimulationManagerExperimental >> storage [

	^ storage
]

{ #category : #accessing }
MASimulationManagerExperimental >> storage: anObject [

	storage := anObject
]
