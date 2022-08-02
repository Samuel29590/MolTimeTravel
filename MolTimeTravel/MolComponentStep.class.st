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
MolComponentStep >> creations [

	^ creations
]

{ #category : #accessing }
MolComponentStep >> deletions [

	^ deletions
]

{ #category : #accessing }
MolComponentStep >> events [

	^ events
]

{ #category : #initialization }
MolComponentStep >> initialize [

	mementos := OrderedCollection new.
	events := OrderedCollection new.
	services := OrderedCollection new.
	creations := OrderedCollection new.
	deletions := OrderedCollection new.
	activations := OrderedCollection new.
	passivations := OrderedCollection new
]

{ #category : #initialization }
MolComponentStep >> isANewStep [

	mementos size > 0 | (creations size > 0) | (deletions size > 0)
	| (activations size > 0) | (passivations size > 0)
	| (events size > 0) | (services size > 0) ifTrue: [ ^ false ].

	^ true
]

{ #category : #accessing }
MolComponentStep >> mementos [

	^ mementos
]

{ #category : #accessing }
MolComponentStep >> passivations [

	^ passivations
]

{ #category : #initialization }
MolComponentStep >> save: aComponentMemento [

	mementos add: aComponentMemento 
]

{ #category : #initialization }
MolComponentStep >> saveActivationOf: aComponentMemento [

	activations add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveCreationOf: aComponentMemento [

	creations add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveDeletionOf: aComponentMemento [

	deletions add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveEvent: aComponentMemento [

	events add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> savePassivationOf: aComponentMemento [

	passivations add: aComponentMemento
]

{ #category : #initialization }
MolComponentStep >> saveService: aComponentMemento [

	services
	 add: aComponentMemento
]

{ #category : #accessing }
MolComponentStep >> services [

	^ services
]

{ #category : #initialization }
MolComponentStep >> stepAlreadyContains: aComponentMemento [

	| class name |
	class := aComponentMemento componentReference componentClass.
	name := aComponentMemento componentReference componentName.

	mementos do: [ :memento | 
		name = memento componentReference componentName ifTrue: [ 
			class = memento componentReference componentClass ifTrue: [ ^ true.  ] ] ].

	^ false
]
