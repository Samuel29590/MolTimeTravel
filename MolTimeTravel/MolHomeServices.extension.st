Extension { #name : #MolHomeServices }

{ #category : #'*MolTimeTravel' }
MolHomeServices >> activateComponent: aComponentClass named: aName [

	| component |
	self
		assert: [ aComponentClass isNotNil ]
		description: [ '[Molecule] Component class should be not nil.' ].
	self
		assert: [ aName isNotNil ]
		description: [ '[Molecule] Component name should be not nil.' ].

	"get to be activated component instance"
	component := self instanceOf: aComponentClass named: aName.
	component ifNil: [ 
		^ ComponentNotFoundError signal:
			  'Can not activate a non instanciated component' ].

	"remove from waiting activation list"
	waitingForActivation remove: component ifAbsent: [ 
		^ ComponentAlreadyActivatedError signal:
			  'Component is already activated.' ].

	component componentConnector activateComponent.

	"--------------------------Time Travel--------------------------"
	component isUsingTimeTravel ifTrue: [ 
		component getTimeTravelServicesProvider isNotFoundServices ifFalse: [ "Subscription to the Time Travel event" 
			component getTimeTravelEventsSubscriber subscribe: component ] ].
	"---------------------------------------------------------------"
	component componentActivate.

	component triggerEvent: #activateComponent with: component.

	MolUtils log:
		aComponentClass printString , ' named: ' , aName printString
		, ' is activated.'.

	"manage connexion between components"
	MolComponentManager default locatorServices 
		resolveWaitingSubscriptions: component.

	^ component
]

{ #category : #'*MolTimeTravel' }
MolHomeServices >> instanciateComponent: aComponentClass named: aName [
	| error component connector deployed |
	
	aComponentClass ifNil:[^nil].
	error := self checkInstanciationOfComponent: aComponentClass named: aName.
	error ifNotNil:[error signal. ^nil].
	
	component := aComponentClass new componentName: aName; yourself.
	MolUtils log: aComponentClass printString , ' named: ' , aName printString , ' is instanciated.'.

	deployed := self deployedComponents at: aComponentClass.
	deployed at: component componentName put: component.
	
	"connect the component to the component model and initialize it"
	connector := MolComponentConnector new.
	component componentConnector: connector.
	
	"--------------------------Time Travel--------------------------"
	component isUsingTimeTravel ifTrue:[
	(MolUtils instanceOf: MolTimeTravel named: #default) ifNotNil: [ "Connection to the TimeTravel service." 
		component forServices: TimeTravelServices useProvider: #default ].
	component getTimeTravelServicesProvider isNotFoundServices ifFalse: [ "Subscription to the Time Travel event"
		component getTimeTravelEventsSubscriber subscribe: component.
		component getTimeTravelServicesProvider isRestoring ifFalse: [ "Component notifies its creation" 
			component getTimeTravelServicesProvider creationOf: component ] ]].
	"---------------------------------------------------------------"
	component componentInitialize.
	"--------------------------Time Travel--------------------------"
	component isUsingTimeTravel ifTrue:[
	component getTimeTravelServicesProvider isNotFoundServices ifFalse: [
		component getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state." 
			component saveForTimeTravel ] ]].
	"---------------------------------------------------------------"
	
	component triggerEvent: #instanciateComponent with: component.
	
	"add the component to waiting activation list"
	waitingForActivation add: component.
	
	^component
]

{ #category : #'*MolTimeTravel' }
MolHomeServices >> passivateComponent: aComponentClass named: aName [
	| component |
	
	(aComponentClass isNil or:[aName isNil]) ifTrue:[^self].
		
	"get to be passivated component instance"
	component := self instanceOf: aComponentClass named: aName.
	component ifNil: [
		^ComponentNotFoundError signal: 'Can not passivate a non instanciated component'.
	].

	(self isWaitingForActivation: aComponentClass named: aName) ifTrue:[
		^ComponentAlreadyPassivatedError signal: 'Component is already passivated.' 
	].

	component componentPassivate.
	"--------------------------Time Travel--------------------------"
	component isUsingTimeTravel ifTrue: [ 
		component getTimeTravelServicesProvider isNotFoundServices ifFalse: [ "Subscription to the Time Travel event" 
			component getTimeTravelEventsSubscriber unsubscribe: component ] ].
	"---------------------------------------------------------------"
	
	component componentConnector passivateComponent.
	component triggerEvent: #passivateComponent with: component.
	
	MolUtils log: aComponentClass printString , ' named: ' , aName printString, ' is passivated.'.

	"add in waiting activation list"
	waitingForActivation add: component.
	
	^ component
]

{ #category : #'*MolTimeTravel' }
MolHomeServices >> removeComponent: aComponentClass named: aName [
	| removedComponent deployedComponentsOfThisClass |
	(aComponentClass isNil or:[aName isNil]) ifTrue:[^nil].
	
	"Get to be removed component instance"
	removedComponent := self instanceOf: aComponentClass named: aName.
	removedComponent ifNil:[ ComponentNotFoundError signal: 'Can not remove a non instanciated component'. ^nil ].
	
	"Passivation of the component if activated"
	(self isWaitingForActivation: aComponentClass named: aName) ifFalse: [ self passivateComponent: aComponentClass named: aName ].
	waitingForActivation remove: removedComponent ifAbsent:[
		"The Component has not been activated, log and proceed to the remove"
		MolUtils log: aComponentClass printString , ' named: ' , aName printString , ' has not been activated during the session.'.
	].
	
	"Remove the component"

	"--------------------------Time Travel--------------------------"
	removedComponent isUsingTimeTravel ifTrue:[
	removedComponent getTimeTravelServicesProvider isNotFoundServices ifFalse: [
		removedComponent getTimeTravelServicesProvider isRestoring ifFalse: [ "Component saves its state."
			removedComponent saveForTimeTravel.
			"Component notifies its deletion"
			removedComponent getTimeTravelServicesProvider deletionOf: removedComponent ] ]].
	"---------------------------------------------------------------"
	
	removedComponent componentRemove.
	removedComponent componentConnector: nil.
	removedComponent triggerEvent: #removeComponent with: removedComponent.
	
	"Get deployed component instances of this component class"
	deployedComponentsOfThisClass := self deployedComponents at: aComponentClass ifAbsent:[
		MolUtils log: aComponentClass printString , ' named: ' , aName printString , ' is not a deployed component class.'.
	].
	
	"Remove the instance"
	deployedComponentsOfThisClass removeKey: aName ifAbsent: [ 
		MolUtils log: aComponentClass printString , ' named: ' , aName printString , ' is not a deployed component class.'.
	].

	"Resolve connections between components"
	"Unlink component connection between this old component and not yet activated components"
	waitingForActivation do: [ :waitingComponent | self resetComponentConnection: waitingComponent withRemovedComponent: removedComponent ].
	"Unlink component connection between this old component and activated components"	
	self deployedComponents keysAndValuesDo: [ :class :componentDictionary | 
		componentDictionary valuesDo: [ :activatedComponent | 
			self resetComponentConnection: activatedComponent withRemovedComponent: removedComponent.
		] 
	].
	
	"Finish release of the component life-cycle"
	removedComponent componentName: nil.
	MolUtils log: aComponentClass printString , ' named: ' , aName printString , ' is removed.'.
	^removedComponent
]
