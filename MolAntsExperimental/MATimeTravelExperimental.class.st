Class {
	#name : #MATimeTravelExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMATimeTravelExperimentalType + TMATimeTravelExperimentalServices',
	#classTraits : 'MolComponentImpl classTrait + TMATimeTravelExperimentalType classTrait + TMATimeTravelExperimentalServices classTrait',
	#instVars : [
		'history',
		'isSaving',
		'isRestoring',
		'test'
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
			self getTMATimeTravelExperimentalEventsNotifier restore: k values: v ] ]
]

{ #category : #services }
MATimeTravelExperimental >> save: aComponent at: aStep [

	| variablesOfTheComponent |
	isSaving ifTrue: [ 
		variablesOfTheComponent := OrderedCollection new.

		0 to: aComponent class instSize do: [ :index | 
			index > 0 ifTrue: [ 
				variablesOfTheComponent add: (aComponent instVarAt: index) copy ] ].

		test := variablesOfTheComponent.

		(history includesKey: aStep) ifFalse: [ 
			history add: aStep -> Dictionary new ].

		(history at: aStep) add:
			aComponent componentName -> variablesOfTheComponent ]
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
