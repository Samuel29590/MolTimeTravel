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

	| dict orderedCollection |
	dict := Dictionary new.
	aSimulationManager insects isDictionary ifTrue: [ 
		aSimulationManager insects keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | list add: value class -> value componentName ].
			dict add: k -> list ] ].
	insects := dict.
	
	componentName := aSimulationManager componentName.
	nbInsects := aSimulationManager nbInsects.
	
	
	orderedCollection := OrderedCollection new.
		aSimulationManager ants isCollection ifTrue: [ 
		aSimulationManager ants do: [ :value | 
			orderedCollection add: value class -> value componentName  ] ].
	ants := orderedCollection.
	
	nbAnts := aSimulationManager nbAnts.
	storage := aSimulationManager storage
]

{ #category : #accessing }
MASimulationMemento >> storage [

	^ storage
]
