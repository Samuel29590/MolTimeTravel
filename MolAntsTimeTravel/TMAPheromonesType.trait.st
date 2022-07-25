"
I'm the pheromone type trait.
"
Trait {
	#name : #TMAPheromonesType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsTimeTravel
}

{ #category : #'accessing - events' }
TMAPheromonesType classSide >> consumedComponentEvents [

	<componentContract>
	^ { 
		  TMASimulationToGlobalEvents.
		  TimeTravelEvents }
]

{ #category : #'accessing - services' }
TMAPheromonesType classSide >> providedComponentServices [
	<componentContract>
	^ {TMAPheromoneServices} 
]

{ #category : #'accessing - services' }
TMAPheromonesType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationServices .TimeTravelServices }
]
