Trait {
	#name : #TMATimeTravelExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMATimeTravelExperimentalType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMATimeTravelExperimentalEvents }
]

{ #category : #'accessing - services' }
TMATimeTravelExperimentalType classSide >> providedComponentServices [

	<componentContract>
	^ { TMATimeTravelExperimentalServices }
]
