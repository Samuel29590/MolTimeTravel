Class {
	#name : #MASimulationMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'restoringStep',
		'insects',
		'nbInsects',
		'ants',
		'nbAnts',
		'storage'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MASimulationMemento >> ants [

	^ ants
]

{ #category : #accessing }
MASimulationMemento >> insects [

	^ insects
]

{ #category : #accessing }
MASimulationMemento >> nbAnts [

	^ nbAnts
]

{ #category : #accessing }
MASimulationMemento >> nbInsects [

	^ nbInsects
]

{ #category : #accessing }
MASimulationMemento >> restoringStep [

	^ restoringStep
]

{ #category : #actions }
MASimulationMemento >> save: aSimulationManager [

	| dict |
	dict := Dictionary new.
	aSimulationManager insects keysAndValuesDo: [ :k :v | 
		| list |
		list := OrderedCollection new.
		v do: [ :value | list add: value ].
		dict add: k -> list ].

	insects := dict.
	componentName := aSimulationManager componentName.
	restoringStep := aSimulationManager restoringStep.
	nbInsects := aSimulationManager nbInsects.
	ants := aSimulationManager ants.
	nbAnts := aSimulationManager nbAnts.
	storage := aSimulationManager storage
]

{ #category : #accessing }
MASimulationMemento >> storage [

	^ storage
]
