Class {
	#name : #BaselineOfMolTimeTravel,
	#superclass : #BaselineOf,
	#category : #BaselineOfMolTimeTravel
}

{ #category : #baselines }
BaselineOfMolTimeTravel >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		
		"Load Molecule"
		spec
			baseline: 'Molecule'
			with: [ spec repository: 'github://Samuel29590/Molecule' ].
			
		"Load Bloc"
		spec
			baseline: 'Bloc'
			with: [ spec repository: 'github://pharo-graphics/Bloc/src' ].

		
		spec package: 'MolTimeTravel'. 
		spec package: 'MolAntsTimeTravel'.
		spec package: 'MolGPSTimeTravel'.
		spec package: 'MolRandomPrinterTimeTravel'. ]
]
