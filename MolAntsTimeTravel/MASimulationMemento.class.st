Class {
	#name : #MASimulationMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ants',
		'feedingPoints',
		'insects',
		'storage',
		'step'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #accessing }
MASimulationMemento >> getAnts [

	^ ants
]

{ #category : #accessing }
MASimulationMemento >> getFeedingPoints [

^ feedingPoints
]

{ #category : #accessing }
MASimulationMemento >> getInsects [

	^ insects
]

{ #category : #accessing }
MASimulationMemento >> getStep [

	^ step
]

{ #category : #accessing }
MASimulationMemento >> getStorage [

	^ storage
]

{ #category : #accessing }
MASimulationMemento >> redo [ 
	
	self restoreValues 
]

{ #category : #actions }
MASimulationMemento >> save: aSimulationManager [

	| dict orderedCollection |
	componentClass := aSimulationManager class.
	componentName := aSimulationManager componentName.

	step := aSimulationManager getStep.
	
	dict := Dictionary new.
	aSimulationManager getInsects isDictionary ifTrue: [ 
		aSimulationManager getInsects keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | list add: value class -> value componentName ].
			dict add: k -> list ] ].
	insects := dict.

	dict := Dictionary new.
	aSimulationManager getFeedingPoints isDictionary ifTrue: [ 
		aSimulationManager getFeedingPoints keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | list add: value class -> value componentName ].
			dict add: k -> list ] ].
	feedingPoints := dict.

	orderedCollection := OrderedCollection new.
	aSimulationManager getAnts isCollection ifTrue: [ 
		aSimulationManager getAnts do: [ :value | 
			orderedCollection add: value class -> value componentName ] ].
	ants := orderedCollection.

	storage := aSimulationManager getStorage
]

{ #category : #accessing }
MASimulationMemento >> undo [

	self restoreValues
]
