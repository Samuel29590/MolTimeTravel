Trait {
	#name : #MolGPSDataServices,
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #MolGPSTimeTravel
}

{ #category : #services }
MolGPSDataServices >> getAccuracyRadiusInMeters [
	"Get and return the accuracy of the GPS depending quality of signal and quantity of connected satellites"
]
