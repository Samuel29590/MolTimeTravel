Class {
	#name : #MAComponentRemoveMemento,
	#superclass : #MAComponentMemento,
	#instVars : [
		'componentClass'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentRemoveMemento >> componentClass [

	^ componentClass
]

{ #category : #actions }
MAComponentRemoveMemento >> isCreation [ 
	^false
]

{ #category : #actions }
MAComponentRemoveMemento >> isRemoving [

	^ true
]

{ #category : #actions }
MAComponentRemoveMemento >> save: aComponent [

	componentName := aComponent componentName.
	componentClass := aComponent class
]
