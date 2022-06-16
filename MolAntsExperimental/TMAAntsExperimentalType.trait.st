Trait {
	#name : #TMAAntsExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMAAntsExperimentalType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationExperimentalToGlobalEvents.TMATimeTravelExperimentalEvents }
]

{ #category : #'accessing - events' }
TMAAntsExperimentalType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMAAntsEvents }
]

{ #category : #'accessing - services' }
TMAAntsExperimentalType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationExperimentalServices .TMATimeTravelExperimentalServices }
]
