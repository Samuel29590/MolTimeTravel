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
				                  restoringStep := restoringStep - 1.
				                  self restoreAtStep: restoringStep.
				                  (Delay forMilliseconds:
					                   MASimulationManagerExperimental
						                   simulationStepDurationInMs) wait ].
			                  isPlayingBackward := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name:
				'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ]
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
			timeTravelLoop := nil.
		] ifFalse: [ 
			isReplaying := true.
			timeTravelLoop := [ 
			                  [ restoringStep <( history size - 1) ] whileTrue: [ 
				                  restoringStep := restoringStep + 1.
				                  self restoreAtStep: restoringStep.
				                  (Delay forMilliseconds:
					                   MASimulationManagerExperimental
						                   simulationStepDurationInMs) wait ].
			                  isReplaying := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name: 'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ].
			
]

{ #category : #services }
MATimeTravelExperimental >> restoreAtStep: aStep [

	| stepToIndex mementos |
	isRestoring ifFalse: [ ^ self ].

	stepToIndex := aStep + 1.
	stepToIndex < 1 | (stepToIndex > history size) ifTrue: [ ^ self ].

	mementos := (history at: stepToIndex) mementos.
	mementos do: [ :memento | 
		self getTMATimeTravelExperimentalEventsNotifier
			restore: memento componentName
			values: memento ].

	timeTravelIndex := stepToIndex.
	restoringStep := aStep.
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
		history add: MAComponentsMementos new ].

	(history at: stepToIndex) save: aComponentMemento.

	timeTravelIndex := stepToIndex.
	restoringStep := aStep.
]

{ #category : #services }
MATimeTravelExperimental >> startTimeTravel [

	isSaving := false.
	isRestoring := true.
	timeTravelIndex := history size.
	restoringStep := history size -1.
]

{ #category : #services }
MATimeTravelExperimental >> stopTimeTravel [

	isSaving := true.
	isRestoring := false.
	timeTravelIndex := history size.
	restoringStep := history size-1.
]
