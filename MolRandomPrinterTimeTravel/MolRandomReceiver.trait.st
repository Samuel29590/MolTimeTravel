Trait {
	#name : #MolRandomReceiver,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolRandomPrinterTimeTravel
}

{ #category : #'accessing - events' }
MolRandomReceiver classSide >> consumedComponentEvents [

	<componentContract>
	^ { MolRandomSenderEvents.TimeTravelEvents }
]

{ #category : #'accessing - services' }
MolRandomReceiver classSide >> usedComponentServices [

	<componentContract>
	^ { TimeTravelServices }
]
