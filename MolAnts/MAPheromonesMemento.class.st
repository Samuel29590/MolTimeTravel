Class {
	#name : #MAPheromonesMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'maxIntensity',
		'pheromonesDict',
		'pheromonesReturnDict'
	],
	#category : #MolAnts
}

{ #category : #accessing }
MAPheromonesMemento >> maxIntensity [

	^ maxIntensity
]

{ #category : #accessing }
MAPheromonesMemento >> pheromonesDict [

	^ pheromonesDict
]

{ #category : #accessing }
MAPheromonesMemento >> pheromonesReturnDict [

	^ pheromonesReturnDict
]

{ #category : #'undo - undo' }
MAPheromonesMemento >> redo [

	self restoreValues.
]

{ #category : #actions }
MAPheromonesMemento >> save: aPheromones [

	componentClass := aPheromones class.
	componentName := aPheromones componentName.
	maxIntensity := aPheromones maxIntensity.
	pheromonesDict := aPheromones pheromonesDict.
	pheromonesReturnDict := aPheromones pheromonesReturnDict
]

{ #category : #'undo - undo' }
MAPheromonesMemento >> undo [

	self restoreValues
]
