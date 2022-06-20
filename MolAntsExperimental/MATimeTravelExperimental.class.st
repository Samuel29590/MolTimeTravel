Class {
	#name : #MATimeTravelExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMATimeTravelExperimentalType + TMATimeTravelExperimentalServices',
	#classTraits : 'MolComponentImpl classTrait + TMATimeTravelExperimentalType classTrait + TMATimeTravelExperimentalServices classTrait',
	#instVars : [
		'history',
		'isSaving',
		'isRestoring'
	],
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MATimeTravelExperimental >> componentInitialize [

	"here write the code corresponding to component initialisation phase"

	history := OrderedCollection new.
	isSaving := true.
	isRestoring := false
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
MATimeTravelExperimental >> restoreAtStep: aStep [

	| stepToIndex mementos |
	stepToIndex := aStep + 1.

	isRestoring ifTrue: [ 
		stepToIndex < 1 | (stepToIndex > history size) ifTrue: [ 
			
			Transcript
				show: 'Index ERROR !';
				cr.
			^ self ].

		mementos := (history at: stepToIndex) mementos.
		mementos do: [ :memento | 
			self getTMATimeTravelExperimentalEventsNotifier
				restore: memento componentName
				values: memento ] ]
]

{ #category : #services }
MATimeTravelExperimental >> save: aComponentMemento at: aStep [

	| stepToIndex |
	stepToIndex := aStep + 1.

	[history size < stepToIndex] whileTrue: [ 
		history add: MAComponentsMementos new ].
	
	( history at: stepToIndex ) save: aComponentMemento.
]

{ #category : #services }
MATimeTravelExperimental >> startTimeTravel [

	isSaving := false.
	isRestoring := true.
]

{ #category : #services }
MATimeTravelExperimental >> stopTimeTravel [

	isSaving := true.
	isRestoring := false
]
