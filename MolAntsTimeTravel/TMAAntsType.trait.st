"
I'm the ant type trait.
"
Trait {
	#name : #TMAAntsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsTimeTravel
}

{ #category : #'accessing - events' }
TMAAntsType classSide >> consumedComponentEvents [

	<componentContract>
	^ { 
		  TMASimulationToGlobalEvents.
		  TMATimeTravelEvents }
]

{ #category : #'accessing - services' }
TMAAntsType classSide >> providedComponentServices [
	<componentContract>
	^ {TMAAntServices } 
]

{ #category : #'accessing - services' }
TMAAntsType classSide >> usedComponentServices [

	<componentContract>
	^ { 
		  TMAStageServices.
		  TMASimulationServices.
		  TMATimeTravelServices }
]
