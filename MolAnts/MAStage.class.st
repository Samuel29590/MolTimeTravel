"
The actual implementation of the TMAStageType: MAStage, describe the stage of one ant. The stage manages the life cycle of an ant, it determines when an ant is an egg, an adult or when the ant is dead. It also sends to the role the order to do the simulation step and to move.

Variables :

-eggStateDurationInMs, is an integer to determine the duration in ms of the egg state of the ant.

-adultStateDurationInMs, is an integer to determine the duration in ms of the adult state of the ant.
"
Class {
	#name : #MAStage,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAStageType + TMAStageServices + TMATimeTravelExperimentalEvents + TMATimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAStageType classTrait + TMAStageServices classTrait + TMATimeTravelExperimentalEvents classTrait + TMATimeTravelEvents classTrait',
	#instVars : [
		'eggStateDurationInMs',
		'adultStateDurationInMs'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAStage >> adultStateDurationInMs [

	^ adultStateDurationInMs
]

{ #category : #'life cycle' }
MAStage >> componentActivate [

.self getTMATimeTravelEventsSubscriber subscribe: self.

	
]

{ #category : #'life cycle' }
MAStage >> componentInitialize [

	"Initialization of the MAStage component."

	eggStateDurationInMs := (Random new next * 5000) rounded + 1000.
	adultStateDurationInMs := (Random new next * 25000) rounded + 25000.
	self initializeRole.

	self forServices: TMATimeTravelServices useProvider: #TimeTravel.

	self forServices: TMASimulationServices useProvider: #default.

	self getTMATimeTravelServicesProvider isRestoring ifFalse: [ "stage notify the creation"
		self getTMATimeTravelServicesProvider
			creationOf: self
			at: self getTMASimulationServicesProvider step ]
]

{ #category : #'life cycle' }
MAStage >> componentPassivate [

	
.
	self getTMATimeTravelEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAStage >> componentRemove [

	"Removing of the MAStage component."

	self removeRole.
	eggStateDurationInMs := nil.
	adultStateDurationInMs := nil.
	stageName := nil.
	role := nil.

	"stage notify its remove"

	self getTMATimeTravelServicesProvider isRestoring ifFalse: [ 
		self getTMATimeTravelServicesProvider
			removeOf: self
			at: self getTMASimulationServicesProvider step ]
]

{ #category : #private }
MAStage >> computeStageFor: anAnt [

	"Checking if an egg hatch."

	self getStageName = #egg ifTrue: [ 
		anAnt ageInMs > eggStateDurationInMs ifTrue: [ "If the egg hatch, adding the role as a producer of TMARoleService associate to this MAStage."
			stageName := #adult.
			self
				forServices: TMARoleServices
				useProvider: (#role , self componentName asSymbol) asSymbol ].
		^ self ].

	"Checking if an adult is dead."

	self getStageName = #adult ifTrue: [ 
		anAnt ageInMs > adultStateDurationInMs ifTrue: [ "If the adult is dead, notify the MASimulationManager."
			stageName := #dead.
			self getTMAStageEventsNotifier stageChanged: stageName for: anAnt ].
		^ self ]
]

{ #category : #private }
MAStage >> doSimulationStepFor: anAnt [

	self computeStageFor: anAnt.
	self getStageName = #adult ifTrue: [ 
		self getRole doSimulationStepFor: anAnt ]
]

{ #category : #accessing }
MAStage >> eggStateDurationInMs [

	^ eggStateDurationInMs
]

{ #category : #role }
MAStage >> getRole [

	^ role
]

{ #category : #role }
MAStage >> getRoleName [

	^ role getRoleName
]

{ #category : #role }
MAStage >> getStageName [

	^ stageName ifNil: [ stageName := #egg ].
]

{ #category : #'component accessing' }
MAStage >> getTMARoleServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMARoleServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMARoleServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #'component accessing' }
MAStage >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMASimulationServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #'component accessing' }
MAStage >> getTMAStageEventsNotifier [
	^self eventsNotifiers at: TMAStageEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMAStageEvents name: nil].
]

{ #category : #'component accessing' }
MAStage >> getTMATimeTravelEventsSubscriber [
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
MAStage >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #initialization }
MAStage >> initializeRole [

	"Initialization of the role of an ant."

	| x |
	"The first ant is always a queen."
	componentName = #stageAnt1 ifTrue: [ 
		role := MAQueen start: (#role , self componentName asSymbol) asSymbol.
		^ self ].

	x := Random new nextIntegerBetween: 1 and: 100.
	x = 1 ifTrue: [ 
		role := MAQueen start: (#role , self componentName asSymbol) asSymbol.
		^ self ].
	x < 26 ifTrue: [ 
		role := MAFighter start: (#role , self componentName asSymbol) asSymbol.
		^ self ].
	x <= 100 ifTrue: [ 
		role := MAWorker start: (#role , self componentName asSymbol) asSymbol.
		^ self ]
]

{ #category : #testing }
MAStage >> isAlive [
	^ stageName ~= #dead.
]

{ #category : #role }
MAStage >> moveFrom: anAnt [

	"Perform the moving action of the role."

	self getStageName ~= #adult ifTrue: [ ^ anAnt position ].
	^ self getTMARoleServicesProvider moveFrom: anAnt
]

{ #category : #'life cycle' }
MAStage >> removeRole [

	"Deleting the role associate to the stage."

	role ifNotNil: [ 
		role class stop: (#role , self componentName asSymbol) asSymbol. role := nil. ]
]

{ #category : #events }
MAStage >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	eggStateDurationInMs  := aMemento eggStateDurationInMs.
	adultStateDurationInMs  := aMemento adultStateDurationInMs 
]
