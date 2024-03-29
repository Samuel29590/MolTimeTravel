"
I'm the role type trait.
"
Trait {
	#name : #TMARoleType,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolAntsTimeTravel
}

{ #category : #'accessing - events' }
TMARoleType classSide >> consumedComponentEvents [

	<componentContract>
	^ { TimeTravelEvents }
]

{ #category : #'accessing - events' }
TMARoleType classSide >> producedComponentEvents [
	<componentContract>
	^ {TMARoleEvents} 
]

{ #category : #'accessing - services' }
TMARoleType classSide >> providedComponentServices [
	<componentContract>
	^ {TMARoleServices} 
]

{ #category : #'accessing - services' }
TMARoleType classSide >> usedComponentServices [

	<componentContract>
	^ { 
		  TMASimulationServices.TimeTravelServices }
]
