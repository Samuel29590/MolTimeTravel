Class {
	#name : #MATimeTravelExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMATimeTravelExperimentalType + TMATimeTravelExperimentalServices',
	#classTraits : 'MolComponentImpl classTrait + TMATimeTravelExperimentalType classTrait + TMATimeTravelExperimentalServices classTrait',
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
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MATimeTravelExperimental >> componentInitialize [

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
MATimeTravelExperimental >> componentRemove [

	"here write the code corresponding to component remove phase"

	history := nil.
]

{ #category : #services }
MATimeTravelExperimental >> creationOf: aComponentMemento at: aStep [

	| stepToIndex |
	stepToIndex := aStep + 1.

	[ history size < stepToIndex ] whileTrue: [ 
		history add: MAComponentStep new ].

	(history at: stepToIndex) saveCreationOf: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep
]

{ #category : #'component accessing' }
MATimeTravelExperimental >> getTMATimeTravelExperimentalEventsNotifier [
	^self eventsNotifiers at: TMATimeTravelExperimentalEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TMATimeTravelExperimentalEvents name: nil].
]

{ #category : #services }
MATimeTravelExperimental >> isPlayingBackward [

	^ isPlayingBackward
]

{ #category : #services }
MATimeTravelExperimental >> isReplaying [

	^ isReplaying
]

{ #category : #services }
MATimeTravelExperimental >> isRestoring [

	^ isRestoring
]

{ #category : #services }
MATimeTravelExperimental >> playBackward [

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
MATimeTravelExperimental >> removeOf: aComponentMemento at: aStep [

	| stepToIndex |
	stepToIndex := aStep + 1.

	[ history size < stepToIndex ] whileTrue: [ 
		history add: MAComponentStep new ].

	(history at: stepToIndex) saveRemoveOf: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep
]

{ #category : #services }
MATimeTravelExperimental >> replay [

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
MATimeTravelExperimental >> restoreAtStep: aStep [

	| stepToIndex componentsLifeCycles mementos |
	isRestoring ifFalse: [ ^ self ].

	stepToIndex := aStep + 1.
	stepToIndex < 1 | (stepToIndex > history size) ifTrue: [ ^ self ].

	"Undo"
	aStep < restoringStep ifTrue: [ 
		componentsLifeCycles := (history at: stepToIndex + 1)
			                        componentsLifeCycles.
		componentsLifeCycles do: [ :componentLifeCycle | 
			componentLifeCycle isCreation ifTrue: [ 
				componentLifeCycle componentClass stop:
					componentLifeCycle componentName ].
			componentLifeCycle isDeletion ifTrue: [ 
				componentLifeCycle componentClass start:
					componentLifeCycle componentName ] ] ].
	"Redo"
	restoringStep < aStep ifTrue: [ 
		componentsLifeCycles := (history at: stepToIndex)
			                        componentsLifeCycles.
		componentsLifeCycles do: [ :componentLifeCycle | 
			componentLifeCycle isCreation ifTrue: [ 
				componentLifeCycle componentClass start:
					componentLifeCycle componentName ].
			componentLifeCycle isDeletion ifTrue: [ 
				componentLifeCycle componentClass stop:
					componentLifeCycle componentName ] ] ].

	"Restoration of the state of components"
	mementos := (history at: stepToIndex) mementos.
	mementos do: [ :memento | 
		self getTMATimeTravelExperimentalEventsNotifier
			restore: memento componentName
			values: memento ].

	timeTravelIndex := stepToIndex.
	restoringStep := aStep
]

{ #category : #services }
MATimeTravelExperimental >> restoreOneStepAfter [

	self restoreAtStep: restoringStep +1
]

{ #category : #services }
MATimeTravelExperimental >> restoreOneStepBefore [

	self restoreAtStep:
		restoringStep -1
]

{ #category : #services }
MATimeTravelExperimental >> restoringStep [ 

	^restoringStep 
]

{ #category : #services }
MATimeTravelExperimental >> save: aComponentMemento at: aStep [

	| stepToIndex |
	stepToIndex := aStep + 1.

	[ history size < stepToIndex ] whileTrue: [ 
		history add: MAComponentStep new ].

	(history at: stepToIndex) save: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep.
]

{ #category : #services }
MATimeTravelExperimental >> startTimeTravel [

	isSaving := false.
	isRestoring := true.
	timeTravelIndex := history size.
	restoringStep := history size - 1.
	self getTMATimeTravelExperimentalEventsNotifier startTimeTravel
]

{ #category : #services }
MATimeTravelExperimental >> stopTimeTravel [

	isRestoring ifTrue: [ 



	timeTravelIndex := history size.
	restoringStep := history size - 1.
			self restoreAtStep:
			restoringStep.
		isSaving := true.
	isRestoring := false.
	self getTMATimeTravelExperimentalEventsNotifier stopTimeTravel].
	



]
