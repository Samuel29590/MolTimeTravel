Class {
	#name : #MolSimulationMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'ants',
		'nbAnts',
		'feedingPoints',
		'insects',
		'storage',
		'step'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolSimulationMemento >> getAnts [

	^ ants
]

{ #category : #accessing }
MolSimulationMemento >> getFeedingPoints [

^ feedingPoints
]

{ #category : #accessing }
MolSimulationMemento >> getInsects [

	^ insects
]

{ #category : #accessing }
MolSimulationMemento >> getNbAnts [

	^ nbAnts
]

{ #category : #accessing }
MolSimulationMemento >> getStep [

	^ step
]

{ #category : #accessing }
MolSimulationMemento >> getStorage [

	^ storage
]

{ #category : #accessing }
MolSimulationMemento >> redo [ 
	
	self restoreValues 
]

{ #category : #actions }
MolSimulationMemento >> save: aSimulationManager [

	| dict orderedCollection |
	componentReference := MolComponentReference newFrom: aSimulationManager.

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
					v do: [ :value | list add: (MolComponentReference newFrom: value) ].
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
					v do: [ :value | list add: (MolComponentReference newFrom: value) ].
					dict add: k -> list ] ].
			feedingPoints := dict ]
		ifNil: [ feedingPoints := nil ].

	orderedCollection := OrderedCollection new.
	aSimulationManager getAnts
		ifNotNil: [ 
			aSimulationManager getAnts isCollection ifTrue: [ 
				aSimulationManager getAnts do: [ :value | 
					orderedCollection add: (MolComponentReference newFrom: value) ] ].
			ants := orderedCollection ]
		ifNil: [ ants := nil ]
]

{ #category : #accessing }
MolSimulationMemento >> undo [

	self restoreValues
]
