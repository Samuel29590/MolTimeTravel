Class {
	#name : #MASimulationManagerExperimental,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerExperimentalType + TMASimulationExperimentalServices + TMATimeTravelExperimentalEvents',
	#classTraits : 'TMASimulationManagerExperimentalType classTrait + TMASimulationExperimentalServices classTrait + TMATimeTravelExperimentalEvents classTrait',
	#instVars : [
		'simulationThread',
		'step',
		'restoringStep',
		'insects',
		'nbInsects',
		'ants',
		'nbAnts',
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

{ #category : #'life cycle' }
MASimulationManagerExperimental >> componentActivate [

	"Activation of the MASimulationManager component."

	super componentActivate.
	isRunning := true.
	
		self getTMATimeTravelExperimentalEventsSubscriber subscribe:
		self
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

	| name ant |
	1 to: 2 do: [ :e | 
		nbAnts := nbAnts + 1.
		name := ('Ant' , nbAnts printString) asSymbol.
		ant := MAAntExperimental start: name.
		ant position: self class simulationAntHillPosition.

		"Adding the ant to the OrderedCollection of ants"
		ants add: ant.
		self getTMATimeTravelExperimentalServicesProvider save: ant at: step]
]

{ #category : #'life cycle' }
MASimulationManagerExperimental >> createInsects [

	"Creation of a new insect"

	| name insect |
	1 to: 2 do: [ :e | 
		nbInsects := nbInsects + 1.
		name := ('Insect' , nbInsects printString) asSymbol.
		insect := MAInsectExperimental start: name.
		insect position:
			(Random new nextIntegerBetween: 1 and: self class simulationWidth)
			@
			(Random new nextIntegerBetween: 1 and: self class simulationHeight).

		"Adding the insect to the OrderedCollection of insects"
		insects add: insect position -> insect.
		self getTMATimeTravelExperimentalServicesProvider save: insect at: step  ]
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

	insects do: [ :e | MAInsectExperimental stop: e componentName ].
	insects := nil.
	nbInsects := 0
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

{ #category : #'component accessing' }
MASimulationManagerExperimental >> start [

	MATimeTravelExperimental start: 'TimeTravel'.
	self
		forServices: TMATimeTravelExperimentalServices
		useProvider: #TimeTravel.
	isRunning := true.
	isRestoring := false.
	simulationThread := nil.
	step := 0.
	restoringStep := 0.
	ants := OrderedCollection new.
	nbAnts := 0.
	insects := Dictionary new.
	nbInsects := 0.
	MAGroundExperimental start: 'Ground'.
	self createAnts.
	self createInsects.
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
						                    step := step + 1.
						                    restoringStep := step.
						                    self
							                    getTMASimulationExperimentalToGlobalEventsNotifier 
							                    simulationStepSent: step.
							self
							                    getTMASimulationExperimentalToGlobalEventsNotifier 
							                    updateView.
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
