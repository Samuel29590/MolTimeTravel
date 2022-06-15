Trait {
	#name : #TMASimulationManagerExperimentalType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsExperimental
}

{ #category : #'accessing - events' }
TMASimulationManagerExperimentalType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMATimeTravelExperimentalEvents }
]

{ #category : #'accessing - events' }
TMASimulationManagerExperimentalType classSide >> producedComponentEvents [

	<componentContract>
	^ { TMASimulationExperimentalToGlobalEvents }
]

{ #category : #'accessing - services' }
TMASimulationManagerExperimentalType classSide >> providedComponentServices [

	<componentContract>
	^ { TMASimulationExperimentalServices }
]

{ #category : #'accessing - services' }
TMASimulationManagerExperimentalType classSide >> usedComponentServices [

	<componentContract>
	^ { TMATimeTravelExperimentalServices }
]
