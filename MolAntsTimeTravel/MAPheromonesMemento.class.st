Class {
	#name : #MAPheromonesMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'maxIntensity',
		'pheromonesDict',
		'pheromonesReturnDict'
	],
	#category : #MolAntsTimeTravel
}

{ #category : #accessing }
MAPheromonesMemento >> getMaxIntensity [

	^ maxIntensity
]

{ #category : #accessing }
MAPheromonesMemento >> getPheromonesDict [

	^ pheromonesDict
]

{ #category : #accessing }
MAPheromonesMemento >> getPheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'undo - undo' }
MAPheromonesMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAPheromonesMemento >> save: aPheromones [

	| dict dictReturn |
	componentClass := aPheromones class.
	componentName := aPheromones componentName.
	maxIntensity := aPheromones getMaxIntensity.

	dict := Dictionary new.
	aPheromones getPheromonesDict keysAndValuesDo: [ :k :v | 
		| assoc |
		assoc := v key class -> v key componentName -> v value.
		dict at: k put: assoc ].
	pheromonesDict := dict.

	dictReturn := Dictionary new.
	aPheromones getPheromonesReturnDict keysAndValuesDo: [ :k :v |
		dictReturn at: k put: v ].
	pheromonesReturnDict := dictReturn
]

{ #category : #'undo - undo' }
MAPheromonesMemento >> undo [

	self restoreValues
]
