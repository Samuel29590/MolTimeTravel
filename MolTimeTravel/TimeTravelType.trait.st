Trait {
	#name : #TimeTravelType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolTimeTravel
}

{ #category : #'accessing - events' }
TimeTravelType classSide >> producedComponentEvents [

	<componentContract>
	^ { TimeTravelEvents }
]

{ #category : #'accessing - services' }
TimeTravelType classSide >> providedComponentServices [

	<componentContract>
	^ { TimeTravelServices }
]
