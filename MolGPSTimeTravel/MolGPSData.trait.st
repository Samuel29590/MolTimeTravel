"
The GPSData component type uses the Molecule base Type MolComponentType. 
This base Type provides the skeleton methods providedComponentServices and producedComponentEvents.
"
Trait {
	#name : #MolGPSData,
	#traits : 'MolComponentType',
	#classTraits : 'MolComponentType classTrait',
	#category : #MolGPSTimeTravel
}

{ #category : #'accessing - events' }
MolGPSData classSide >> consumedComponentEvents [

	<componentContract>
	^ { TimeTravelEvents  }
]

{ #category : #'accessing - events' }
MolGPSData classSide >> producedComponentEvents [
<componentContract>		
	^{MolGPSDataEvents} 
]

{ #category : #'accessing - services' }
MolGPSData classSide >> providedComponentServices [
<componentContract>	
	^{ MolGPSDataServices  } 
]

{ #category : #'accessing - services' }
MolGPSData classSide >> usedComponentServices [

	<componentContract>
	^ { TimeTravelServices  }
]
