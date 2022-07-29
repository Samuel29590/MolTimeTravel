Trait {
	#name : #MolRandomSender,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolRandomPrinterTimeTravel
}

{ #category : #'accessing - events' }
MolRandomSender classSide >> consumedComponentEvents [

	<componentContract>
	^ { TimeTravelEvents }
]

{ #category : #'accessing - events' }
MolRandomSender classSide >> producedComponentEvents [
	<componentContract>
	^ {MolRandomSenderEvents} 
]

{ #category : #'accessing - services' }
MolRandomSender classSide >> usedComponentServices [

	<componentContract>
	^ { TimeTravelServices }
]
