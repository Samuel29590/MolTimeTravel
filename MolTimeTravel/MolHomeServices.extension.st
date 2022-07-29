Extension { #name : #MolHomeServices }

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
