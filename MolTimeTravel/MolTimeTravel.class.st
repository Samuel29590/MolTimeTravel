Class {
	#name : #MolTimeTravel,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TimeTravelType + TimeTravelServices',
	#classTraits : 'MolComponentImpl classTrait + TimeTravelType classTrait + TimeTravelServices classTrait',
	#instVars : [
		'history',
		'currentStep',
		'lastStep',
		'isSaving',
		'isRestoring',
		'isReplaying',
		'isPlayingBackward',
		'timeTravelLoop',
		'mySpace',
		'lastStepView',
		'currentStepView',
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
	#category : #MolTimeTravel
}

{ #category : #'life cycle' }
MolTimeTravel >> componentInitialize [

	"here write the code corresponding to component initialisation phase"

	isSaving := true.
	isRestoring := false.
	isReplaying := false.
	isPlayingBackward := false.
	timeTravelLoop := nil.
	lastStep := 2.
	currentStep := 2.
	history := OrderedCollection new.
	history add: MolComponentStep new.
	history add: MolComponentStep new.

	mySpace := BlSpace new.
	mySpace extent: 800 @ 200.
	mySpace title: 'TimeTravel Panel'.
	self createTimeTravelPanel.

	inspector := MolComponentManager default homeServices
		             deployedComponents inspect.

	mySpace show
]

{ #category : #'life cycle' }
MolTimeTravel >> componentRemove [

	"here write the code corresponding to component remove phase"

	self stopTimeTravelPanelLoop.

	inspector ifNotNil: [ inspector close ].
	mySpace ifNotNil: [ mySpace close ].

	history := nil.
	lastStep := nil.
	currentStep := nil.
	isSaving := nil.
	isRestoring := nil.
	isReplaying := nil.
	isPlayingBackward := nil.
	timeTravelLoop := nil.
	mySpace := nil.
	lastStepView := nil.
	currentStepView := nil.
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
MolTimeTravel >> createTimeTravelPanel [

	| labelText label button |
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
	lastStepView := BlTextElement new
		                relocate: mySpace width / 10 @ 40;
		                background: Color transparent;
		                text: '000' asRopedText.
	timeTravelPanel addChild: lastStepView.

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding returningStep to the panel."

	timeTravelPanel addChild: ((BlTextElement new
			  relocate: mySpace width / 10 * 5 @ 20;
			  background: Color transparent) text:
			 'Returning Step :' asRopedText).
	currentStepView := BlTextElement new
		                   relocate: mySpace width / 10 * 5 @ 40;
		                   background: Color transparent;
		                   text: '000' asRopedText.
	timeTravelPanel addChild: currentStepView.

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

	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"--------------------------------------------------------------------------------------------------------------------------"
	"Adding Stop button"
	button := BlElement new
		          background: Color red;
		          geometry: (BlRoundedRectangleGeometry cornerRadius: 2);
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
		          relocate:
			          MASimulationManager simulationWidth / 10 * 9 @ 160;
		          addEventHandler: (BlEventHandler
				           on: BlClickEvent
				           do: [ :anEvent | 
					           button isVisible ifTrue: [ 
										self stopTimeTravel .
							           self class stop: self componentName ].
					           anEvent consumed: true ]).
	labelText := 'Stop' asRopedText
		             foreground: Color black;
		             fontSize: 16;
		             fontName: 'Helvetica';
		             thin.
	label := BlTextElement new.
	label text: labelText.
	button addChild: label.
	timeTravelPanel addChild: button.

	self startTimeTravelPanelLoop
]

{ #category : #services }
MolTimeTravel >> creationOf: aComponent [

	| aComponentMemento |
	aComponentMemento := MolComponentCreationMemento new save: aComponent.

	(history at: currentStep) isANewStep ifFalse: [ self nextStep ].

	(history at: currentStep) saveCreationOrDeletionOf: aComponentMemento.

	self saveTheApplication
]

{ #category : #services }
MolTimeTravel >> deletionOf: aComponent [

	| aComponentMemento |
	aComponentMemento := MolComponentDeletionMemento new save: aComponent.

	(history at: currentStep) isANewStep ifFalse: [ self nextStep ].
	
	(history at: currentStep) saveCreationOrDeletionOf: aComponentMemento.

	self saveTheApplication
]

{ #category : #'component accessing' }
MolTimeTravel >> getTimeTravelEventsNotifier [
	^self eventsNotifiers at: TimeTravelEvents ifAbsent: [^MolNotFoundEventsNotifier new interface: TimeTravelEvents name: nil].
]

{ #category : #testing }
MolTimeTravel >> isOnTheFirstStep [

	^ currentStep = 1
]

{ #category : #testing }
MolTimeTravel >> isOnTheLastStep [

	^ currentStep = lastStep 
]

{ #category : #services }
MolTimeTravel >> isRestoring [

	^ isRestoring
]

{ #category : #services }
MolTimeTravel >> nextStep [

	currentStep := currentStep + 1.
	lastStep := lastStep + 1.
	history add: MolComponentStep new
]

{ #category : #'life cycle' }
MolTimeTravel >> playBackward [

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
			                  [ currentStep > 1 ] whileTrue: [ 
				                  self restoreOneStepBefore.
				                  (Delay forMilliseconds: 10) wait ].
			                  isPlayingBackward := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name: 'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ]
]

{ #category : #'life cycle' }
MolTimeTravel >> replay [

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
			                  [ currentStep < lastStep ] whileTrue: [ 
				                  self restoreOneStepAfter .
				                  (Delay forMilliseconds: 10)
					                  wait ].
			                  isReplaying := false.
			                  timeTravelLoop ifNil: [ ^ self ].
			                  timeTravelLoop terminate.
			                  timeTravelLoop := nil ] newProcess priority:
				                  Processor userBackgroundPriority.
			timeTravelLoop name: 'Molecule TimeTravelLoop Process'.
			timeTravelLoop resume ]
]

{ #category : #'life cycle' }
MolTimeTravel >> restoreAtStep: aStep [

	| componentsLifeCycles mementos events |
	isRestoring ifFalse: [ ^ self ].

	currentStep < 1 | (currentStep > lastStep) ifTrue: [ ^ self ].

	"Undo"
	aStep < currentStep ifTrue: [ "Remove or create components"
		componentsLifeCycles := (history at: (aStep + 1)) creationsAndDeletions.
		componentsLifeCycles do: [ :componentLifeCycle | 
			componentLifeCycle undo ].

		"Restoration of the state of components"
		mementos := (history at: aStep) mementos.
		mementos do: [ :memento | memento undo ].

		"events undo"
		events := (history at: aStep) events.
		events do: [ :event | event undo ] ].

	"Redo"
	currentStep < aStep ifTrue: [ "Remove or create components"
		componentsLifeCycles := (history at: aStep) creationsAndDeletions.
		componentsLifeCycles do: [ :componentLifeCycle | 
			componentLifeCycle redo ].

		"Restoration of the state of components"
		mementos := (history at: aStep) mementos.
		mementos do: [ :memento | memento redo ].

		"Replay the events"
		events := (history at: aStep) events.
		events do: [ :event | event redo ] ]
]

{ #category : #'life cycle' }
MolTimeTravel >> restoreOneStepAfter [
 currentStep < lastStep  ifTrue: [ 
	self restoreAtStep: currentStep + 1.
	currentStep := currentStep + 1]
]

{ #category : #'life cycle' }
MolTimeTravel >> restoreOneStepBefore [
 currentStep > 1 ifTrue: [ 
	self restoreAtStep: currentStep - 1.
	currentStep := currentStep - 1]
]

{ #category : #services }
MolTimeTravel >> save: aComponentMemento [

	(history at: currentStep) save: aComponentMemento.
]

{ #category : #services }
MolTimeTravel >> saveEvent: aMethodName performBy: aComponent withParameters: someParameters [

	| aComponentMemento |
	aComponentMemento := MolComponentEventMemento new
		                     saveEvent: aMethodName
		                     performBy: aComponent
		                     withParameters: someParameters.

	(history at: currentStep) isANewStep ifFalse: [ self nextStep ].

	(history at: currentStep) saveEvent: aComponentMemento.

	self saveTheApplication
]

{ #category : #services }
MolTimeTravel >> saveTheApplication [

	self getTimeTravelEventsNotifier saveForTimeTravel.

	self nextStep.
]

{ #category : #'life cycle' }
MolTimeTravel >> startTimeTravel [

	isRestoring ifFalse: [ 
		isSaving := false.
		isRestoring := true.
		self getTimeTravelEventsNotifier startTimeTravel ]
]

{ #category : #'life cycle' }
MolTimeTravel >> startTimeTravelPanelLoop [

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
MolTimeTravel >> stopTimeTravel [

	isRestoring ifTrue: [ 
		isPlayingBackward ifFalse: [ 
			isReplaying ifFalse: [ 
				isReplaying := true.
				[ currentStep < lastStep ] whileTrue: [ 
					self restoreOneStepAfter  ].
				isReplaying := false.
				isSaving := true.
				isRestoring := false.
				self getTimeTravelEventsNotifier stopTimeTravel ] ] ]
]

{ #category : #'life cycle' }
MolTimeTravel >> stopTimeTravelPanelLoop [

	"Stoping the time travel panel's view loop."


	panelLoop ifNil: [ ^ self ].
	panelLoop terminate.
	panelLoop := nil
]

{ #category : #'life cycle' }
MolTimeTravel >> updatePanelView [

	"Modify each elements of the time travel panel. It permit to keep the view up to date with the simulation."

	lastStepView   text: lastStep   asRopedText.
	currentStepView  text: currentStep  asRopedText.

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
