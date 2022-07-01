Class {
	#name : #MATimeTravel,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMATimeTravelType + TMATimeTravelServices',
	#classTraits : 'MolComponentImpl classTrait + TMATimeTravelType classTrait + TMATimeTravelServices classTrait',
	#instVars : [
		'history',
		'restoringStep',
		'isSaving',
		'isRestoring',
		'isReplaying',
		'isPlayingBackward',
		'timeTravelLoop',
		'timeTravelIndex'
	],
	#category : #MolAnts
}

{ #category : #'life cycle' }
MATimeTravel >> componentInitialize [

	"here write the code corresponding to component initialisation phase"

	history := OrderedCollection new.
	isSaving := true.
	isRestoring := false.
	isReplaying := false.
	isPlayingBackward := false.
	timeTravelLoop := nil.
	timeTravelIndex := 0.
	restoringStep := 0
]

{ #category : #'life cycle' }
MATimeTravel >> componentRemove [

	"here write the code corresponding to component remove phase"

	history := nil.
]

{ #category : #services }
MATimeTravel >> creationOf: aComponent at: aStep [

	| stepToIndex aComponentMemento |
	stepToIndex := aStep + 1.

	[ history size < stepToIndex ] whileTrue: [ 
		history add: MAComponentStep new ].

	aComponentMemento := MAComponentCreationMemento new save: aComponent.

	(history at: stepToIndex) saveCreationOrDeletionOf: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep
]

{ #category : #'component accessing' }
MATimeTravel >> getTMATimeTravelEventsNotifier [
	^self eventsNotifiers at: TMATimeTravelEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMATimeTravelEvents name: nil].
]

{ #category : #services }
MATimeTravel >> isPlayingBackward [

	^ isPlayingBackward
]

{ #category : #services }
MATimeTravel >> isReplaying [

	^ isReplaying
]

{ #category : #services }
MATimeTravel >> isRestoring [

	^ isRestoring
]

{ #category : #services }
MATimeTravel >> playBackward [

	isRestoring ifFalse: [ ^ self ].
	isReplaying ifTrue: [ ^ self ].

	isPlayingBackward
		ifTrue: [ 
			isPlayingBackward := false.
			timeTravelLoop ifNil: [ ^ self ].
			timeTravelLoop terminate.
			timeTravelLoop := nil ]
		ifFalse: [ 
			isPlayingBackward := true.
			timeTravelLoop := [ 
			                  [ restoringStep > 0 ] whileTrue: [ 
				                  self restoreAtStep: (restoringStep-1).
				                  (Delay forMilliseconds:
					                   MASimulationManagerExperimental
						                   simulationStepDurationInMs) wait ].
			                  isPlayingBackward := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name: 'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ]
]

{ #category : #services }
MATimeTravel >> removeOf: aComponent at: aStep [

	| stepToIndex aComponentMemento |
	stepToIndex := aStep + 1.

	[ history size < stepToIndex ] whileTrue: [ 
		history add: MAComponentStep new ].
	
	aComponentMemento := MAComponentDeletionMemento new save:aComponent.
	
	(history at: stepToIndex) saveCreationOrDeletionOf: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep
]

{ #category : #services }
MATimeTravel >> replay [

	isRestoring ifFalse: [ ^ self ].
	isPlayingBackward ifTrue: [ ^ self ].

	isReplaying
		ifTrue: [ 
			isReplaying := false.
			timeTravelLoop ifNil: [ ^ self ].
			timeTravelLoop terminate.
			timeTravelLoop := nil ]
		ifFalse: [ 
			isReplaying := true.
			timeTravelLoop := [ 
			                  [ restoringStep < (history size - 1) ] 
				                  whileTrue: [ 
					                  self restoreAtStep: (restoringStep+1).
					                  (Delay forMilliseconds:
						                   MASimulationManagerExperimental
							                   simulationStepDurationInMs) wait ].
			                  isReplaying := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name: 'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ]
]

{ #category : #services }
MATimeTravel >> restoreAtStep: aStep [

	| stepToIndex componentsLifeCycles mementos |
	isRestoring ifFalse: [ ^ self ].

	stepToIndex := aStep + 1.
	stepToIndex < 1 | (stepToIndex > history size) ifTrue: [ ^ self ].

	"Undo"
	aStep < restoringStep ifTrue: [ "Remove or create components"
		componentsLifeCycles := (history at: stepToIndex + 1)
			                        creationsAndDeletions.
		componentsLifeCycles do: [ :componentLifeCycle | 
			componentLifeCycle undo ].

		"Restoration of the state of components"
		mementos := (history at: stepToIndex) mementos.
		mementos do: [ :memento | memento undo ] ].
	"Redo"
	restoringStep < aStep ifTrue: [ "Remove or create components"
		componentsLifeCycles := (history at: stepToIndex)
			                        creationsAndDeletions.
		componentsLifeCycles do: [ :componentLifeCycle | 
			componentLifeCycle redo ].

		"Restoration of the state of components"
		mementos := (history at: stepToIndex) mementos.
		mementos do: [ :memento | memento redo ] ].

	timeTravelIndex := stepToIndex.
	restoringStep := aStep
]

{ #category : #services }
MATimeTravel >> restoreOneStepAfter [

	self restoreAtStep: restoringStep +1
]

{ #category : #services }
MATimeTravel >> restoreOneStepBefore [

	self restoreAtStep:
		restoringStep -1
]

{ #category : #services }
MATimeTravel >> restoringStep [ 

	^restoringStep 
]

{ #category : #services }
MATimeTravel >> save: aComponentMemento at: aStep [

	| stepToIndex |
	stepToIndex := aStep + 1.

	[ history size < stepToIndex ] whileTrue: [ 
		history add: MAComponentStep new ].

	(history at: stepToIndex) save: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep.
]

{ #category : #services }
MATimeTravel >> startTimeTravel [

	isSaving := false.
	isRestoring := true.
	timeTravelIndex := history size.
	restoringStep := history size - 1.
	self getTMATimeTravelExperimentalEventsNotifier startTimeTravel
]

{ #category : #services }
MATimeTravel >> stopTimeTravel [

	isRestoring ifTrue: [ 
		self restoreAtStep: (history size - 1).
		isSaving := true.
		isRestoring := false.
		self getTMATimeTravelExperimentalEventsNotifier stopTimeTravel ]
]
