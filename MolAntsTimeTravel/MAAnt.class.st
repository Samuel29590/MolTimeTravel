"
The actual implementation of the TMAAntsType: MAAnt, describe one ant. For each ant created there is also one MAStage component and one MARole component created. There are associate through their component name (example: Ant29, StageAnt29 and RoleStageAnt29). The stage of the ant is created by the ant and the role is created by the stage. The implementation of the ant MAAnt permit to increase the age of the ant and to send to the stage the order to do the simulation step and to move.

Variables :

-position, is a point.

-ageInMs, is an integer.
"
Class {
	#name : #MAAnt,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAAntsType + TMAAntServices + TMASimulationToGlobalEvents + TMATimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAAntsType classTrait + TMAAntServices classTrait + TMASimulationToGlobalEvents classTrait + TMATimeTravelEvents classTrait',
	#instVars : [
		'position',
		'ageInMs'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #'life cycle' }
MAAnt >> componentActivate [

	"Activation of the MAAnt component."

	self getTMASimulationToGlobalEventsSubscriber subscribe: self.
	
	"--------------------------Time Travel--------------------------"
	"Subscription to the Time Travel event"
	self getTMATimeTravelEventsSubscriber subscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAAnt >> componentInitialize [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		"Connection to the TimeTravel service."
		self forServices: TMATimeTravelServices useProvider: #default.
		"Subscription to the Time Travel event"
		self getTMATimeTravelEventsSubscriber subscribe: self.
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component notifies its creation" 
			self getTMATimeTravelServicesProvider creationOf: self ] ].
	"---------------------------------------------------------------"
	
	"Initialization of the MAAnt component."

	self forServices: TMASimulationServices useProvider: #default.

	self
		forServices: TMAStageServices
		useProvider: (#stage , self componentName asSymbol) asSymbol.

	self initializeStage.
	ageInMs := 0.
	position := MASimulationManager simulationAntHillPosition.

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component saves its state."
			self saveForTimeTravel ] ]
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAAnt >> componentPassivate [

	"Passivating the MAAnt component."

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self.
	
	"--------------------------Time Travel--------------------------"
	"Unsubscribe from the Time Travel event"
	self getTMATimeTravelEventsSubscriber unsubscribe: self.
	"---------------------------------------------------------------"
]

{ #category : #'life cycle' }
MAAnt >> componentRemove [

	"--------------------------Time Travel--------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component saves its state."
			self saveForTimeTravel.
			"Component notifies its deletion"
			self getTMATimeTravelServicesProvider deletionOf: self ] ].
	"---------------------------------------------------------------"

	"Removing the MAAnt component."

	position := nil.
	ageInMs := nil
]

{ #category : #private }
MAAnt >> doSimulationStep [

	"Updating the age of the ant, then performing the action and the move of the ant."

	self getStage isAlive ifTrue: [ 
		ageInMs := ageInMs + MASimulationManager simulationStepDurationInMs.
		self getStage doSimulationStepFor: self.
		self position: (self getStage moveFrom: self) ]
]

{ #category : #accessing }
MAAnt >> getAgeInMs [

	^ ageInMs
]

{ #category : #services }
MAAnt >> getFeedingPoints [

	^ self getTMASimulationServicesProvider getFeedingPoints
]

{ #category : #services }
MAAnt >> getInsects [

	^ self getTMASimulationServicesProvider getInsects
]

{ #category : #services }
MAAnt >> getPheromonesDict [

	^ self getTMASimulationServicesProvider getPheromonesDict.
]

{ #category : #services }
MAAnt >> getPheromonesReturnDict [ 

	^ self getTMASimulationServicesProvider getPheromonesReturnDict
]

{ #category : #accessing }
MAAnt >> getPosition [

	^ position
]

{ #category : #services }
MAAnt >> getRole [

	"Returning the MARole's subclass associate to the MAStage associate to this ant."

	^ stage getRole
]

{ #category : #accessing }
MAAnt >> getRoleName [

	stage ifNil: [ ^ nil ].
	^ stage getRoleName
]

{ #category : #services }
MAAnt >> getStage [

	"Returning the MAStage associate to this ant."

	^ stage
]

{ #category : #accessing }
MAAnt >> getStageName [

	stage ifNil: [ ^ nil ].
	^ stage getStageName
]

{ #category : #'component accessing' }
MAAnt >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMASimulationServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MAAnt >> getTMASimulationToGlobalEventsSubscriber [
	| eventsSymbol eventsSubscriber itf |
	itf := TMASimulationToGlobalEvents.
	eventsSymbol := self eventsSubscribers at: itf ifAbsent: [^MolNotFoundEventsSubscriber new interface: itf name: nil].
	eventsSymbol isCollection
	 	ifTrue: 
			[eventsSubscriber := MolComponentManager default locatorServices 
						searchEventsSubscriberFor: TMASimulationToGlobalEvents named: eventsSymbol ]. 
	^eventsSubscriber
]

{ #category : #'component accessing' }
MAAnt >> getTMAStageServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMAStageServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMAStageServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MAAnt >> getTMATimeTravelEventsSubscriber [
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
MAAnt >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #stage }
MAAnt >> initializeStage [

	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
	self getTMATimeTravelServicesProvider isRestoring ifTrue: [ ^ self ]].

	stage := MAStage start:
		         (#stage , self componentName asSymbol) asSymbol
]

{ #category : #accessing }
MAAnt >> position: aPoint [

	position := aPoint
]

{ #category : #events }
MAAnt >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	position := aMemento getPosition.
	ageInMs := aMemento getAgeInMs.
	aMemento getStage ifNil:[stage := nil] ifNotNil:[
	stage := MolUtils
		         instanceOf: aMemento getStage key
		         named: aMemento getStage value ].
]

{ #category : #events }
MAAnt >> saveForTimeTravel [

		| memento |
	memento := MAAntMemento new.

	self getTMATimeTravelServicesProvider
		save: (memento save: self)
]

{ #category : #'events - lifecycle' }
MAAnt >> simulationStepSent: aStep [

	self doSimulationStep
]
