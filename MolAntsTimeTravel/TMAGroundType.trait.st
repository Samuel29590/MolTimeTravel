"
I'm the ground type trait.
"
Trait {
	#name : #TMAGroundType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsTimeTravel
}

{ #category : #'accessing - events' }
TMAGroundType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TMASimulationToGlobalEvents.
	TimeTravelEvents }
]

{ #category : #'accessing - services' }
TMAGroundType classSide >> usedComponentServices [

	<componentContract>
	^ { 
		  TMAPheromoneServices.
		  TMASimulationServices.
		  TimeTravelServices }
]
