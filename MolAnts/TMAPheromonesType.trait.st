"
I'm the pheromone type trait.
"
Trait {
	#name : #TMAPheromonesType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAnts
}

{ #category : #'accessing - events' }
TMAPheromonesType classSide >> consumedComponentEvents [

	<componentContract>
	^ { 
		  TMASimulationToGlobalEvents.
		  TMATimeTravelEvents }
]

{ #category : #'accessing - services' }
TMAPheromonesType classSide >> providedComponentServices [
	<componentContract>
	^ {TMAPheromoneServices} 
]

{ #category : #'accessing - services' }
TMAPheromonesType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationServices .TMATimeTravelServices }
]
