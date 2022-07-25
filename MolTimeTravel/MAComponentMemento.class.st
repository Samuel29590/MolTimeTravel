Class {
	#name : #MAComponentMemento,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MAComponentMemento >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MAComponentMemento >> componentName [

	^ componentName
]

{ #category : #'undo - undo' }
MAComponentMemento >> redo [
]

{ #category : #accessing }
MAComponentMemento >> restoreValues [
 | instance |
	instance := (MolUtils instanceOf: componentClass named: componentName) .
	instance ifNotNil: [ instance restoreFrom: self. ]
]

{ #category : #actions }
MAComponentMemento >> save: aComponent [
]

{ #category : #'undo - undo' }
MAComponentMemento >> undo [

	
]
