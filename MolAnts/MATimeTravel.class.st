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
		'timeTravelIndex',
		'mySpace',
		'returningStepView',
		'buttonStartTimeTravel',
		'buttonStopTimeTravel',
		'buttonOneStepBefore',
		'buttonOneStepAfter',
		'buttonPlayBackward',
		'buttonReplay',
		'timeTravelPanel',
		'panelLoop',
		'inspector'
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
	restoringStep := 0.

	mySpace := BlSpace new.
	mySpace extent: 800 @ 200.
	mySpace title: 'TimeTravel Panel'.
	self createTimeTravelPanel.

	inspector := MolComponentManager default homeServices
		             deployedComponents inspect.

	mySpace show
]

{ #category : #'life cycle' }
MATimeTravel >> componentRemove [

	"here write the code corresponding to component remove phase"

	self stopTimeTravelPanelLoop.
	
	inspector ifNotNil: [ inspector close ].
	mySpace ifNotNil: [ mySpace close ].

	history := nil.
	restoringStep := nil.
	isSaving := nil.
	isRestoring := nil.
	isReplaying := nil.
	isPlayingBackward := nil.
	timeTravelLoop := nil.
	timeTravelIndex := nil.
	mySpace := nil.
	returningStepView := nil.
	buttonStartTimeTravel := nil.
	buttonStopTimeTravel := nil.
	buttonOneStepBefore := nil.
	buttonOneStepAfter := nil.
	buttonPlayBackward := nil.
	buttonReplay := nil.
	timeTravelPanel := nil.
	inspector := nil
]

{ #category : #'life cycle' }
MATimeTravel >> createTimeTravelPanel [

	| labelText label |
	timeTravelPanel := BlElement new.
	timeTravelPanel background: Color gray.
	timeTravelPanel constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	mySpace addChild: timeTravelPanel.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding returningStep to the panel."

	timeTravelPanel addChild: ((BlTextElement new
			  relocate: mySpace width / 10 @ 20;
			  background: Color transparent) text:
			 'Returning Step :' asRopedText).
	returningStepView := BlTextElement new
		                     relocate: mySpace width / 10 @ 40;
		                     background: Color transparent;
		                     text: '000' asRopedText.
	timeTravelPanel addChild: returningStepView.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding the Start time trave button"
	buttonStartTimeTravel := BlElement new
		                         background: Color white;
		                         geometry:
			                         (BlRoundedRectangleGeometry cornerRadius:
					                          2);
		                         padding: (BlInsets
				                          top: 8
				                          right: 16
				                          bottom: 8
				                          left: 16);
		                         layout: BlLinearLayout horizontal;
		                         effect: (BlGaussianShadowEffect
				                          color: (Color black alpha: 0.3)
				                          width: 1
				                          offset: 0 @ 2);
		                         constraintsDo: [ :c | 
			                         c horizontal fitContent.
			                         c vertical fitContent ];
		                         relocate: mySpace width / 10 @ 80;
		                         addEventHandler: (BlEventHandler
				                          on: BlClickEvent
				                          do: [ :anEvent | 
					                          buttonStartTimeTravel isVisible 
						                          ifTrue: [ self startTimeTravel ].
					                          anEvent consumed: true ]).
	labelText := 'Start time travel' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonStartTimeTravel addChild: label.
	timeTravelPanel addChild: buttonStartTimeTravel.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding the Stop time trave button"
	buttonStopTimeTravel := BlElement new
		                        background: Color white;
		                        geometry:
			                        (BlRoundedRectangleGeometry cornerRadius: 2);
		                        padding: (BlInsets
				                         top: 8
				                         right: 16
				                         bottom: 8
				                         left: 16);
		                        layout: BlLinearLayout horizontal;
		                        effect: (BlGaussianShadowEffect
				                         color: (Color black alpha: 0.3)
				                         width: 1
				                         offset: 0 @ 2);
		                        constraintsDo: [ :c | 
			                        c horizontal fitContent.
			                        c vertical fitContent ];
		                        relocate: mySpace width / 10 * 3 @ 80;
		                        addEventHandler: (BlEventHandler
				                         on: BlClickEvent
				                         do: [ :anEvent | 
					                         buttonStopTimeTravel isVisible ifTrue: [ 
							                         self stopTimeTravel ].
					                         anEvent consumed: true ]).
	labelText := 'Stop time travel' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonStopTimeTravel addChild: label.
	timeTravelPanel addChild: buttonStopTimeTravel.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding One Step before button"
	buttonOneStepBefore := BlElement new
		                       background: Color white;
		                       geometry:
			                       (BlRoundedRectangleGeometry cornerRadius: 2);
		                       padding: (BlInsets
				                        top: 8
				                        right: 16
				                        bottom: 8
				                        left: 16);
		                       layout: BlLinearLayout horizontal;
		                       effect: (BlGaussianShadowEffect
				                        color: (Color black alpha: 0.3)
				                        width: 1
				                        offset: 0 @ 2);
		                       constraintsDo: [ :c | 
			                       c horizontal fitContent.
			                       c vertical fitContent ];
		                       relocate: mySpace width / 10 * 5 @ 80;
		                       addEventHandler: (BlEventHandler
				                        on: BlClickEvent
				                        do: [ :anEvent | 
					                        buttonOneStepBefore isVisible ifTrue: [ 
							                        self restoreOneStepBefore ].
					                        anEvent consumed: true ]).
	labelText := 'One step before' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonOneStepBefore addChild: label.
	timeTravelPanel addChild: buttonOneStepBefore.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding One Step after button"
	buttonOneStepAfter := BlElement new
		                      background: Color white;
		                      geometry:
			                      (BlRoundedRectangleGeometry cornerRadius: 2);
		                      padding: (BlInsets
				                       top: 8
				                       right: 16
				                       bottom: 8
				                       left: 16);
		                      layout: BlLinearLayout horizontal;
		                      effect: (BlGaussianShadowEffect
				                       color: (Color black alpha: 0.3)
				                       width: 1
				                       offset: 0 @ 2);
		                      constraintsDo: [ :c | 
			                      c horizontal fitContent.
			                      c vertical fitContent ];
		                      relocate: mySpace width / 10 * 7 @ 80;
		                      addEventHandler: (BlEventHandler
				                       on: BlClickEvent
				                       do: [ :anEvent | 
					                       buttonOneStepAfter isVisible ifTrue: [ 
							                       self restoreOneStepAfter ].
					                       anEvent consumed: true ]).
	labelText := 'One step after' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonOneStepAfter addChild: label.
	timeTravelPanel addChild: buttonOneStepAfter.


	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding playing backward button"
	buttonPlayBackward := BlElement new
		                      background: Color white;
		                      geometry:
			                      (BlRoundedRectangleGeometry cornerRadius: 2);
		                      padding: (BlInsets
				                       top: 8
				                       right: 16
				                       bottom: 8
				                       left: 16);
		                      layout: BlLinearLayout horizontal;
		                      effect: (BlGaussianShadowEffect
				                       color: (Color black alpha: 0.3)
				                       width: 1
				                       offset: 0 @ 2);
		                      constraintsDo: [ :c | 
			                      c horizontal fitContent.
			                      c vertical fitContent ];
		                      relocate: mySpace width / 10 * 3 @ 130;
		                      addEventHandler: (BlEventHandler
				                       on: BlClickEvent
				                       do: [ :anEvent | 
					                       buttonPlayBackward isVisible ifTrue: [ 
							                       self playBackward ].
					                       anEvent consumed: true ]).
	labelText := 'Play Backward' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonPlayBackward addChild: label.
	timeTravelPanel addChild: buttonPlayBackward.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding replay button"
	buttonReplay := BlElement new
		                background: Color white;
		                geometry:
			                (BlRoundedRectangleGeometry cornerRadius: 2);
		                padding: (BlInsets
				                 top: 8
				                 right: 16
				                 bottom: 8
				                 left: 16);
		                layout: BlLinearLayout horizontal;
		                effect: (BlGaussianShadowEffect
				                 color: (Color black alpha: 0.3)
				                 width: 1
				                 offset: 0 @ 2);
		                constraintsDo: [ :c | 
			                c horizontal fitContent.
			                c vertical fitContent ];
		                relocate: mySpace width / 10 * 5 @ 130;
		                addEventHandler: (BlEventHandler
				                 on: BlClickEvent
				                 do: [ :anEvent | 
					                 buttonReplay isVisible ifTrue: [ self replay ].
					                 anEvent consumed: true ]).
	labelText := 'Relay' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	buttonReplay addChild: label.
	timeTravelPanel addChild: buttonReplay.
	
	self startTimeTravelPanelLoop
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

{ #category : #testing }
MATimeTravel >> isOnTheFirstStep [ 

	^ restoringStep = 0
]

{ #category : #testing }
MATimeTravel >> isOnTheLastStep [

	^ restoringStep = (history size - 1)
]

{ #category : #services }
MATimeTravel >> isRestoring [

	^ isRestoring
]

{ #category : #'life cycle' }
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
				                  self restoreAtStep: restoringStep - 1.
				                  (Delay forMilliseconds:
					                   MASimulationManager
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

{ #category : #'life cycle' }
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
					                  self restoreAtStep: restoringStep + 1.
					                  (Delay forMilliseconds:
						                   MASimulationManager
							                   simulationStepDurationInMs) wait ].
			                  isReplaying := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name: 'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ]
]

{ #category : #'life cycle' }
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

{ #category : #'life cycle' }
MATimeTravel >> restoreOneStepAfter [

	self restoreAtStep: restoringStep +1
]

{ #category : #'life cycle' }
MATimeTravel >> restoreOneStepBefore [

	self restoreAtStep:
		restoringStep -1
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
MATimeTravel >> saveTheSimulationAt: aStep [

	
	self getTMATimeTravelEventsNotifier saveForTimeTravel: aStep.
]

{ #category : #'life cycle' }
MATimeTravel >> startTimeTravel [

	isRestoring ifFalse: [ 
	isSaving := false.
	isRestoring := true.
	timeTravelIndex := history size.
	restoringStep := history size - 1.
	self getTMATimeTravelEventsNotifier startTimeTravel]
]

{ #category : #'life cycle' }
MATimeTravel >> startTimeTravelPanelLoop [

	"Starting the time travel panel's view loop."

	panelLoop := [ 
	             [ true ] whileTrue: [ 
		             self updatePanelView.
		             (Delay forMilliseconds:
			              MASimulationManager simulationStepDurationInMs) wait ] ] 
		             forkAt: Processor userBackgroundPriority.
	panelLoop name: 'Molecule ViewLoop Process'.
	panelLoop resume
]

{ #category : #'life cycle' }
MATimeTravel >> stopTimeTravel [

	isRestoring ifTrue: [
		isPlayingBackward ifFalse:[  
		isReplaying ifFalse: [ 
			isReplaying := true.
			[ restoringStep < (history size - 1) ] whileTrue: [ 
				self restoreAtStep: restoringStep + 1 ].
			isReplaying := false.
			isSaving := true.
			isRestoring := false.
			self getTMATimeTravelEventsNotifier stopTimeTravel ] ]]
]

{ #category : #'life cycle' }
MATimeTravel >> stopTimeTravelPanelLoop [

	"Stoping the time travel panel's view loop."


	panelLoop ifNil: [ ^ self ].
	panelLoop terminate.
	panelLoop := nil
]

{ #category : #'life cycle' }
MATimeTravel >> updatePanelView [

	"Modify each elements of the time travel panel. It permit to keep the view up to date with the simulation."

	returningStepView text: restoringStep asRopedText.
	
	isRestoring
		ifTrue: [ 
			buttonStartTimeTravel background: Color gray.
			buttonStopTimeTravel background: Color white.
			buttonOneStepBefore background: Color white.
			buttonOneStepAfter background: Color white.
			buttonPlayBackward background: Color white.
			buttonReplay background: Color white.
			isPlayingBackward ifTrue: [ 
				buttonStopTimeTravel background: Color gray.
				buttonOneStepBefore background: Color gray.
				buttonOneStepAfter background: Color gray.
				buttonReplay background: Color gray ].
			isReplaying ifTrue: [ 
				buttonStopTimeTravel background: Color gray.
				buttonOneStepBefore background: Color gray.
				buttonOneStepAfter background: Color gray.
				buttonPlayBackward background: Color gray ].
			self isOnTheFirstStep ifTrue: [ 
				buttonOneStepBefore background: Color gray.
				buttonPlayBackward background: Color gray ].
			self isOnTheLastStep ifTrue: [ 
				buttonOneStepAfter background: Color gray.
				buttonReplay background: Color gray ] ]
		ifFalse: [ 
			buttonStartTimeTravel background: Color white.
			buttonStopTimeTravel background: Color gray.
			buttonOneStepBefore background: Color gray.
			buttonOneStepAfter background: Color gray.
			buttonPlayBackward background: Color gray.
			buttonReplay background: Color gray ]
]
