Class {
	#name : #MASimulationMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'insects',
		'ants',
		'feedingPoints',
		'storage'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MASimulationMemento >> ants [

	^ ants
]

{ #category : #accessing }
MASimulationMemento >> feedingPoints [

^ feedingPoints
]

{ #category : #accessing }
MASimulationMemento >> insects [

	^ insects
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

	dict := Dictionary new.
	aSimulationManager insects isDictionary ifTrue: [ 
		aSimulationManager insects keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | list add: value class -> value componentName ].
			dict add: k -> list ] ].
	insects := dict.

	dict := Dictionary new.
	aSimulationManager feedingPoints isDictionary ifTrue: [ 
		aSimulationManager feedingPoints keysAndValuesDo: [ :k :v | 
			| list |
			list := OrderedCollection new.
			v do: [ :value | list add: value class -> value componentName ].
			dict add: k -> list ] ].
	feedingPoints := dict.

	orderedCollection := OrderedCollection new.
	aSimulationManager ants isCollection ifTrue: [ 
		aSimulationManager ants do: [ :value | 
			orderedCollection add: value class -> value componentName ] ].
	ants := orderedCollection.

	storage := aSimulationManager storage
]

{ #category : #accessing }
MASimulationMemento >> storage [

	^ storage
]

{ #category : #accessing }
MASimulationMemento >> undo [

	self restoreValues
]
