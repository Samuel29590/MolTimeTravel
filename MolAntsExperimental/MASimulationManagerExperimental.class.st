Class {
	#name : #MASimulationManagerExperimental,
	#superclass : #MolAbstractComponentImpl,
	#traits : 'TMASimulationManagerExperimentalType + TMASimulationExperimentalServices',
	#classTraits : 'TMASimulationManagerExperimentalType classTrait + TMASimulationExperimentalServices classTrait',
	#instVars : [
		'simulationThread',
		'step',
		'insects',
		'nbInsects',
		'ants',
		'nbAnts',
		'isRunning'
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
		ants add: ant ]
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
		insects add: ((insect position)->insect)]
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
MASimulationManagerExperimental >> getStep [

	^step
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> getTMASimulationExperimentalToGlobalEventsNotifier [
	^self eventsNotifiers at: TMASimulationExperimentalToGlobalEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMASimulationExperimentalToGlobalEvents name: nil].
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

{ #category : #'component accessing' }
MASimulationManagerExperimental >> start [
	MATimeTravelExperimental start: 'TimeTravel'.
	simulationThread := nil.
	step := 0.
	ants := OrderedCollection new.
	nbAnts := 0.
	insects := Dictionary new.
	nbInsects := 0.
	MAGroundExperimental start: 'Ground'.
	self createAnts.
	self createInsects.
	self startSimulationLoop.
	isRunning := true.
	self getTMASimulationExperimentalToGlobalEventsNotifier started
]

{ #category : #'component accessing' }
MASimulationManagerExperimental >> startSimulationLoop [

	simulationThread ifNil: [ 
		simulationThread := [ 
		                    [ true ] whileTrue: [ 
			                    isRunning ifTrue: [ 
				                    step := step + 1.
				                    self getTMASimulationExperimentalToGlobalEventsNotifier
					                    simulationStepSent.
				                    (Delay forMilliseconds:
					                     self class simulationStepDurationInMs) wait ] ] ]
			                    newProcess priority:
			                    Processor userBackgroundPriority.
		simulationThread name:
			'Molecule SimulationManagerExperimental Process' ].
	simulationThread resume
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
