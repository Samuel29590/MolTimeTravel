"
I'm the insect type trait.
"
Trait {
	#name : #TMAInsectsType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsTimeTravel
}

{ #category : #'accessing - events' }
TMAInsectsType classSide >> consumedComponentEvents [

	<componentContract>
	^ { 
		  TMASimulationToGlobalEvents.
		  TMATimeTravelEvents }
]

{ #category : #'accessing - events' }
TMAInsectsType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMAInsectEvents} 
]

{ #category : #'accessing - services' }
TMAInsectsType classSide >> usedComponentServices [

	<componentContract>
	^ { TMASimulationServices .TMATimeTravelServices  }
]
