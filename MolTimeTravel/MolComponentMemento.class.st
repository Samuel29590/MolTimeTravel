Class {
	#name : #MolComponentMemento,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolComponentMemento >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MolComponentMemento >> componentName [

	^ componentName
]

{ #category : #'undo - undo' }
MolComponentMemento >> redo [
]

{ #category : #accessing }
MolComponentMemento >> restoreValues [
 | instance |
	instance := (MolUtils instanceOf: componentClass named: componentName) .
	instance ifNotNil: [ instance restoreFrom: self. ]
]

{ #category : #actions }
MolComponentMemento >> save: aComponent [
]

{ #category : #'undo - undo' }
MolComponentMemento >> undo [

	
]
