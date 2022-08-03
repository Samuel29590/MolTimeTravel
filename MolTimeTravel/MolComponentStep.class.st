Class {
	#name : #MolComponentStep,
	#superclass : #Object,
	#instVars : [
		'mementos',
		'creations',
		'deletions',
		'activations',
		'passivations',
		'events',
		'services'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolComponentStep >> activations [

	^ activations
]

{ #category : #accessing }
MolComponentStep >> activationsSize [

	activations ifNil:[ ^ 0 ].
	^ activations size.
]

{ #category : #accessing }
MolComponentStep >> creations [

	^ creations
]

{ #category : #accessing }
MolComponentStep >> creationsSize [

	creations ifNil:[ ^ 0 ].
	^ creations size.
]

{ #category : #accessing }
MolComponentStep >> deletions [

	^ deletions
]

{ #category : #accessing }
MolComponentStep >> deletionsSize [

	deletions ifNil:[ ^ 0 ].
	^ deletions size.
]

{ #category : #accessing }
MolComponentStep >> events [

	^ events
]

{ #category : #accessing }
MolComponentStep >> eventsSize [

	events ifNil:[ ^ 0 ].
	^ events size.
]

{ #category : #initialization }
MolComponentStep >> isANewStep [

	mementos isNotNil | creations isNotNil | deletions isNotNil | activations isNotNil | passivations isNotNil | events isNotNil | services isNotNil ifTrue: [ ^ false ].

	^ true
]

{ #category : #accessing }
MolComponentStep >> mementos [

	^ mementos
]

{ #category : #accessing }
MolComponentStep >> mementosSize [

	mementos ifNil:[ ^ 0 ].
	^ mementos size.
]

{ #category : #accessing }
MolComponentStep >> passivations [

	^ passivations
]

{ #category : #accessing }
MolComponentStep >> passivationsSize [

	passivations ifNil:[ ^ 0 ].
	^ passivations size.
]

{ #category : #initialization }
MolComponentStep >> redo [

	"Create components"

	creations ifNotNil: [ creations do: [ :componentLifeCycle | componentLifeCycle redo ] ].

	"Activate components"
	activations ifNotNil: [ activations do: [ :componentLifeCycle | componentLifeCycle redo ] ].

	"Passivate components"
	passivations ifNotNil: [ passivations do: [ :componentLifeCycle | componentLifeCycle redo ] ].

	"Remove components"
	deletions ifNotNil: [ deletions do: [ :componentLifeCycle | componentLifeCycle redo ] ].

	"Restoration of the state of components"
	mementos ifNotNil: [ mementos do: [ :memento | memento redo ] ].

	"Replay the events"
	events ifNotNil: [ events do: [ :event | event redo ] ].

	"Replay the services"
	services ifNotNil: [ services do: [ :service | service redo ] ]
]

{ #category : #initialization }
MolComponentStep >> save: aComponentMemento [

	mementos ifNil: [ mementos := OrderedCollection new ].
	mementos add: aComponentMemento 
]

{ #category : #initialization }
MolComponentStep >> saveActivationOf: aComponentMemento [

	activations ifNil: [ activations := OrderedCollection new ].
	activations add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveCreationOf: aComponentMemento [

	creations ifNil: [ creations := OrderedCollection new ].
	creations add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveDeletionOf: aComponentMemento [

	deletions ifNil: [ deletions := OrderedCollection new ].
	deletions add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveEvent: aComponentMemento [

	events ifNil: [ events := OrderedCollection new ].
	events add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> savePassivationOf: aComponentMemento [

	passivations ifNil: [ passivations := OrderedCollection new ].
	passivations add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveService: aComponentMemento [

	services ifNil: [ services := OrderedCollection new ].
	services add: aComponentMemento
]

{ #category : #accessing }
MolComponentStep >> services [

	^ services
]

{ #category : #accessing }
MolComponentStep >> servicesSize [

	services ifNil:[ ^ 0 ].
	^ services size.
]

{ #category : #initialization }
MolComponentStep >> stepAlreadyContains: aComponentMemento [

	| class name |
	class := aComponentMemento componentReference componentClass.
	name := aComponentMemento componentReference componentName.

	mementos ifNotNil: [ mementos do: [ :memento | 
		name = memento componentReference componentName ifTrue: [ 
			class = memento componentReference componentClass ifTrue: [ ^ true. ] ] ] ].

	^ false
]
