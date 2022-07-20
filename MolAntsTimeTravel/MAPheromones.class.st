"
The actual implementation of the TMAPheromonesType: MAPheromones, manage all the pheromones of the simulation. Pheromones are stored in two dictionaries, one for exploration's pheromones and one for returning's pheromones. Dictionaries has for key: the position and for value: an association: (an Ant -> an Integer). In this association the ant represent the last ant that visits the pheromone and the integer represent the intensity of the pheromone.

Pheromones are created by ants when they are moving on the ground and if an ant moves on a position where a pheromone already exists the pheromone is only update (intensity set to maximum). And at each step of the simulation each pheromone intensity is decreased by one.

Variables :

-maxIntensity, is an integer representing the intensity maximum of the pheromone.

-pheromonesDict, is a dictionary containing every pheromones of exploration. Key: a point. Value: an association (ant->intensity).

-pheromonesReturnDict, is a dictionary containing every pheromones of return. Key: a point. Value: an association (ant->intensity).
"
Class {
	#name : #MAPheromones,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMAPheromonesType + TMAPheromoneServices + TMASimulationToGlobalEvents + TMATimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMAPheromonesType classTrait + TMAPheromoneServices classTrait + TMASimulationToGlobalEvents classTrait + TMATimeTravelEvents classTrait',
	#instVars : [
		'maxIntensity',
		'pheromonesDict',
		'pheromonesReturnDict'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #accessing }
MAPheromones class >> getMaxIntensity [

	^ 200
]

{ #category : #'life cycle' }
MAPheromones >> componentActivate [

	"Activation of the MAPheromones component."

	self getTMASimulationToGlobalEventsSubscriber subscribe: self.

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Subscription to the Time Travel event"
	self getTMATimeTravelEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MAPheromones >> componentInitialize [

	"Initialization of the MAPheromones component."

	self forServices: TMASimulationServices useProvider: #default.
	
	maxIntensity := 100.
	pheromonesDict := Dictionary new.
	pheromonesReturnDict := Dictionary new.

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Connection to the TimeTravel service."
	self forServices: TMATimeTravelServices useProvider: #default.
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [
			"Component notifies its creation" 
			self getTMATimeTravelServicesProvider creationOf: self.
			"Component saves its state."
			self saveForTimeTravel ] ].
]

{ #category : #'life cycle' }
MAPheromones >> componentPassivate [

	"Passivating the MAPheromones component."

	self getTMASimulationToGlobalEventsSubscriber unsubscribe: self.
	
	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	"Unsubscribe from the Time Travel event"
	self getTMATimeTravelEventsSubscriber unsubscribe: self
]

{ #category : #'life cycle' }
MAPheromones >> componentRemove [

	"---------------------------------------------------------------"
	"--------------------------Time Travel--------------------------"
	"---------------------------------------------------------------"
	(MolUtils instanceOf: MATimeTravel named: #default) ifNotNil: [ 
		"Component saves its state."
		self saveForTimeTravel.
		"Component notifies its deletion"
		self getTMATimeTravelServicesProvider isRestoring ifFalse: [ 
			self getTMATimeTravelServicesProvider deletionOf: self ] ].
	
	"Removing the MAPheromones component."

	maxIntensity := nil.
	pheromonesDict := nil.
	pheromonesReturnDict := nil

]

{ #category : #'events - lifecycle' }
MAPheromones >> doSimulationStep [

	"At each step, all pheromones loose 1 to their intensity. If a pheromone has 0 as intensity it's remove from the dictionaries."

	pheromonesDict keysDo: [ :each | 
		pheromonesDict at: each update: [ :v | v value: v value - 1 ].
		(pheromonesDict at: each) value <= 0 ifTrue: [ 
			pheromonesDict removeKey: each ] ].

	pheromonesReturnDict keysDo: [ :each | 
		pheromonesReturnDict at: each update: [ :v | v - 1 ].
		(pheromonesReturnDict at: each) <= 0 ifTrue: [ 
			pheromonesReturnDict removeKey: each ] ]
]

{ #category : #services }
MAPheromones >> getMaxIntensity [

	^ maxIntensity.
]

{ #category : #services }
MAPheromones >> getPheromonesDict [

	^ pheromonesDict.
]

{ #category : #services }
MAPheromones >> getPheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'component accessing' }
MAPheromones >> getTMASimulationServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMASimulationServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMASimulationServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #'component accessing' }
MAPheromones >> getTMASimulationToGlobalEventsSubscriber [
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
MAPheromones >> getTMATimeTravelEventsSubscriber [
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
MAPheromones >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |

	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [nil].
	(servicesSymbol isNil or:[servicesSymbol isSymbol not]) ifTrue: [ ^ MolNotFoundServicesProvider new interface: itf name: nil ].

	servicesProvider := MolComponentManager default locatorServices searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol.
	^servicesProvider
]

{ #category : #events }
MAPheromones >> pheromoneNew: aPoint for: anAnt [

	"Adding or updating a pheromone of exploration at a specific point."

	(pheromonesDict includesKey: aPoint)
		ifFalse: [ "The following code permit to not create pheromones in the ant hill. In order to keep the ant hill clear."
			| pointRectangle antHillRectangle |
			pointRectangle := BlBounds
				                  origin: anAnt getPosition - (20 @ 20)
				                  extent: 40 @ 40.

			antHillRectangle := BlBounds
				                    origin:
				                    MASimulationManager simulationAntHillPosition
				                    extent: 0 @ 0.
			(pointRectangle intersects: antHillRectangle) ifFalse: [ 
				pheromonesDict add: aPoint -> (anAnt -> maxIntensity) ] ]
		ifTrue: [ pheromonesDict at: aPoint put: anAnt -> maxIntensity ]
]

{ #category : #events }
MAPheromones >> pheromoneReturnNew: aPoint for: anAnt [

	"Adding or updating a pheromone of return at a specific point."

	(pheromonesReturnDict includesKey: aPoint)
		ifFalse: [ pheromonesReturnDict add: aPoint -> maxIntensity ]
		ifTrue: [ 
			pheromonesReturnDict
				at: aPoint
				update: [ :v | v - v + maxIntensity ] ]
]

{ #category : #events }
MAPheromones >> restoreFrom: aMemento [

	"Restore variables thanks to a memento."

	maxIntensity := aMemento getMaxIntensity.


	pheromonesDict := Dictionary new.
	aMemento getPheromonesDict keysAndValuesDo: [ :k :v | 
		pheromonesDict
			at: k
			put: (MolUtils instanceOf: v key key named: v key value) -> v value ].

	pheromonesReturnDict := Dictionary new.
	aMemento getPheromonesReturnDict keysAndValuesDo: [ :k :v | 
		pheromonesReturnDict
			at: k
			put:v ]
]

{ #category : #events }
MAPheromones >> saveForTimeTravel [

		| memento |
	memento := MAPheromonesMemento new.

	self getTMATimeTravelServicesProvider
		save: (memento save: self)
]

{ #category : #'events - lifecycle' }
MAPheromones >> simulationStepSent: aStep [

	self doSimulationStep.

	"self saveForTimeTravel: aStep"
]
