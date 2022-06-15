Trait {
	#name : #TMAGroundExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMAGroundExperimentalType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationExperimentalToGlobalEvents . TMATimeTravelExperimentalEvents }
]

{ #category : #'accessing - services' }
TMAGroundExperimentalType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationExperimentalServices. TMATimeTravelExperimentalServices }
]
