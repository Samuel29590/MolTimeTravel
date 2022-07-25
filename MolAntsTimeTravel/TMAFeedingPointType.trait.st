"
I'm the feeding points type trait.
"
Trait {
	#name : #TMAFeedingPointType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsTimeTravel
}

{ #category : #'accessing - events' }
TMAFeedingPointType classSide >> consumedComponentEvents [

	<componentContract>
	^ { 
		  TMASimulationToGlobalEvents .
		  TimeTravelEvents }
]

{ #category : #'accessing - services' }
TMAFeedingPointType classSide >> providedComponentServices [

	<componentContract>
	^ { TMAFeedingPointServices }
]

{ #category : #'accessing - services' }
TMAFeedingPointType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationServices .TimeTravelServices }
]
