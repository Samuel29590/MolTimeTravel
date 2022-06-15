Trait {
	#name : #TMAInsectsExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMAInsectsExperimentalType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationExperimentalToGlobalEvents . TMATimeTravelExperimentalEvents }
]

{ #category : #'accessing - services' }
TMAInsectsExperimentalType classSide >> usedComponentServices [

	<componentContract>
	^ { TMATimeTravelExperimentalServices }
]
