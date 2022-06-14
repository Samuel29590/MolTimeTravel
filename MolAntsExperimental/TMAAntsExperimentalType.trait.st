Trait {
	#name : #TMAAntsExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMAAntsExperimentalType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationExperimentalToGlobalEvents }
]
