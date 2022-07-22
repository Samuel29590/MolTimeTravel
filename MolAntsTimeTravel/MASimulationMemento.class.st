Class {
	#name : #MASimulationMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'ants',
		'nbAnts',
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
MASimulationMemento >> getNbAnts [

	^ nbAnts
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
	storage := aSimulationManager getStorage.
	nbAnts := aSimulationManager getNbAnts.

	dict := Dictionary new.
	aSimulationManager getInsects
		ifNotNil: [ 
			aSimulationManager getInsects isDictionary ifTrue: [ 
				aSimulationManager getInsects keysAndValuesDo: [ :k :v | 
					| list |
					list := OrderedCollection new.
					v do: [ :value | list add: value class -> value componentName ].
					dict add: k -> list ] ].
			insects := dict ]
		ifNil: [ insects := nil ].

	dict := Dictionary new.
	aSimulationManager getFeedingPoints
		ifNotNil: [ 
			aSimulationManager getFeedingPoints isDictionary ifTrue: [ 
				aSimulationManager getFeedingPoints keysAndValuesDo: [ :k :v | 
					| list |
					list := OrderedCollection new.
					v do: [ :value | list add: value class -> value componentName ].
					dict add: k -> list ] ].
			feedingPoints := dict ]
		ifNil: [ feedingPoints := nil ].

	orderedCollection := OrderedCollection new.
	aSimulationManager getAnts
		ifNotNil: [ 
			aSimulationManager getAnts isCollection ifTrue: [ 
				aSimulationManager getAnts do: [ :value | 
					orderedCollection add: value class -> value componentName ] ].
			ants := orderedCollection ]
		ifNil: [ ants := nil ]
]

{ #category : #accessing }
MASimulationMemento >> undo [

	self restoreValues
]
