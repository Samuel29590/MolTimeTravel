Class {
	#name : #MolPheromonesMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'maxIntensity',
		'pheromonesDict',
		'pheromonesReturnDict'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolPheromonesMemento >> getMaxIntensity [

	^ maxIntensity
]

{ #category : #accessing }
MolPheromonesMemento >> getPheromonesDict [

	^ pheromonesDict
]

{ #category : #accessing }
MolPheromonesMemento >> getPheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'undo - undo' }
MolPheromonesMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MolPheromonesMemento >> save: aPheromones [

	| dict dictReturn |
	componentClass := aPheromones class.
	componentName := aPheromones componentName.
	maxIntensity := aPheromones getMaxIntensity.

	aPheromones getPheromonesDict
		ifNotNil: [ 
			dict := Dictionary new.
			aPheromones getPheromonesDict keysAndValuesDo: [ :k :v | 
				| assoc |
				assoc := v key class -> v key componentName -> v value.
				dict at: k put: assoc ].
			pheromonesDict := dict ]
		ifNil: [ pheromonesDict := nil ].

	aPheromones getPheromonesReturnDict
		ifNotNil: [ 
	dictReturn := Dictionary new.
			aPheromones getPheromonesReturnDict keysAndValuesDo: [ :k :v | 
				dictReturn at: k put: v ].
			pheromonesReturnDict := dictReturn ]
		ifNil: [ pheromonesReturnDict := nil ]
]

{ #category : #'undo - undo' }
MolPheromonesMemento >> undo [

	self restoreValues
]
