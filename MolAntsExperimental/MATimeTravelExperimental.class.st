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

	history := Dictionary new.
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
 isRestoring ifTrue: [ 
	aStep < 0 ifTrue: [ ^ self ].
	(history at: aStep) keysAndValuesDo: [ :k :v | 
		self getTMATimeTravelExperimentalEventsNotifier restore: k value: v ]]
]

{ #category : #services }
MATimeTravelExperimental >> save: aComponent at: aStep [

	isSaving ifTrue: [

	(history includesKey: aStep) ifFalse: [ 
		history add: aStep -> Dictionary new ].

	(history at: aStep) add:
		aComponent componentName -> aComponent position]
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
