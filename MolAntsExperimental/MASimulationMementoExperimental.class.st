Class {
	#name : #MASimulationMementoExperimental,
	#superclass : #MAComponentMementoExperimental,
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
MASimulationMementoExperimental >> ants [

	^ ants
]

{ #category : #accessing }
MASimulationMementoExperimental >> insects [

	^ insects
]

{ #category : #accessing }
MASimulationMementoExperimental >> nbAnts [

	^ nbAnts
]

{ #category : #accessing }
MASimulationMementoExperimental >> nbInsects [

	^ nbInsects
]

{ #category : #accessing }
MASimulationMementoExperimental >> redo [ 
	
	self restoreValues 
]

{ #category : #accessing }
MASimulationMementoExperimental >> restoringStep [

	^ restoringStep
]

{ #category : #actions }
MASimulationMementoExperimental >> save: aSimulationManager [

	| dict orderedCollection |
	dict := Dictionary new.
	aSimulationManager insects isDictionary ifTrue: [ 
		aSimulationManager insects keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | list add: value class -> value componentName ].
			dict add: k -> list ] ].
	insects := dict.

	componentClass := aSimulationManager class.
	componentName := aSimulationManager componentName.
	nbInsects := aSimulationManager nbInsects.


	orderedCollection := OrderedCollection new.
	aSimulationManager ants isCollection ifTrue: [ 
		aSimulationManager ants do: [ :value | 
			orderedCollection add: value class -> value componentName ] ].
	ants := orderedCollection.

	nbAnts := aSimulationManager nbAnts.
	storage := aSimulationManager storage
]

{ #category : #accessing }
MASimulationMementoExperimental >> storage [

	^ storage
]

{ #category : #accessing }
MASimulationMementoExperimental >> undo [

	self restoreValues
]
