Trait {
	#name : #TMATimeTravelExperimentalEvents,
	#traits : 'MolComponentEvents',
	#classTraits : 'MolComponentEvents classTrait',
	#category : #MolAntsExperimental
}

{ #category : #events }
TMATimeTravelExperimentalEvents >> restore: aComponentName values: componentValues [

	self componentName = aComponentName ifTrue: [ 
		| compt |
		compt := 1.
		componentValues do: [ :value | 
			self instVarAt: compt put: value.
			compt := compt + 1 ] ]
]
