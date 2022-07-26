Class {
	#name : #BaselineOfMolTimeTravel,
	#superclass : #BaselineOf,
	#category : #BaselineOfMolTimeTravel
}

{ #category : #baselines }
BaselineOfMolTimeTravel >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Load Molecule"
		spec
			baseline: 'Molecule'
			with: [ spec repository: 'github://OpenSmock/Molecule' ].

		"Load Bloc"
		spec
			baseline: 'NewBloc'
			with: [ spec repository: 'github://pharo-graphics/Bloc/src' ].

		spec package: 'MolTimeTravel'.
		spec package: 'MolAntsTimeTravel'.
		spec package: 'MolGPSTimeTravel' ]
]
