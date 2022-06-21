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

{ #category : #'accessing - events' }
TMAInsectsExperimentalType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMAInsectsEvents }
]

{ #category : #'accessing - services' }
TMAInsectsExperimentalType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationExperimentalServices .TMATimeTravelExperimentalServices }
]
