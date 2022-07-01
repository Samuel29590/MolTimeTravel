Trait {
	#name : #TMATimeTravelType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAnts
}

{ #category : #'accessing - events' }
TMATimeTravelType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMATimeTravelEvents }
]

{ #category : #'accessing - services' }
TMATimeTravelType classSide >> providedComponentServices [

	<componentContract>
	^ { TMATimeTravelServices }
]
