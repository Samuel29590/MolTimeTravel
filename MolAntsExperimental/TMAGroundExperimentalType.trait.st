Trait {
	#name : #TMAGroundExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMAGroundExperimentalType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationExperimentalToGlobalEvents }
]

{ #category : #'accessing - services' }
TMAGroundExperimentalType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationExperimentalServices }
]
