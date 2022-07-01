"
The actual implementation of the TMARoleeType: MARole, describe the role of one stage. The role provides the behavior of an ant at each step. Actually roles are implemented by MAQueen, MAFighter or MAWorker that are subclass of MARole. In each different implementation there is one method: doSimulationStepFor: that manage the action of the ant and one method: moveFrom: that manage the position of the ant at each step.
"
Class {
	#name : #MARole,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMARoleType + TMARoleServices + TMATimeTravelExperimentalEvents + TMATimeTravelEvents',
	#classTraits : 'MolComponentImpl classTrait + TMARoleType classTrait + TMARoleServices classTrait + TMATimeTravelExperimentalEvents classTrait + TMATimeTravelEvents classTrait',
	#category : #MolAnts
}

{ #category : #'life cycle' }
MARole >> componentActivate [

	self getTMATimeTravelEventsSubscriber subscribe: self
]

{ #category : #'life cycle' }
MARole >> componentPassivate [

	
.
	self getTMATimeTravelEventsSubscriber unsubscribe: self

	
]

{ #category : #accessing }
MARole >> getRoleName [

	^ roleName.
]

{ #category : #'component accessing' }
MARole >> getTMARoleEventsNotifier [
	^self eventsNotifiers at: TMARoleEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMARoleEvents name: nil].
]

{ #category : #'component accessing' }
MARole >> getTMASimulationServicesProvider [
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
MARole >> getTMATimeTravelEventsSubscriber [
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
MARole >> getTMATimeTravelServicesProvider [
	| servicesSymbol servicesProvider itf |
	itf := TMATimeTravelServices.
	servicesSymbol := self servicesProviders at: itf ifAbsent: [^MolNotFoundServicesProvider new interface: itf name: nil].
	servicesSymbol isSymbol
	 	ifTrue: 
			[servicesProvider := MolComponentManager default locatorServices 
						searchServicesProviderFor: TMATimeTravelServices named: servicesSymbol]. 
	^servicesProvider
]

{ #category : #role }
MARole >> moveFrom: anAnt [
]

{ #category : #events }
MARole >> restoreFrom: aMemento [
]
