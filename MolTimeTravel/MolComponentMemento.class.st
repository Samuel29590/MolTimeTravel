Class {
	#name : #MolComponentMemento,
	#superclass : #Object,
	#instVars : [
		'componentReference'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolComponentMemento >> componentReference [

	^ componentReference 
]

{ #category : #'undo - undo' }
MolComponentMemento >> redo [
]

{ #category : #accessing }
MolComponentMemento >> restoreValues [
 | instance |
	instance := (MolUtils instanceOf: componentReference componentClass named: componentReference componentName) .
	instance ifNotNil: [ instance restoreFrom: self. ]
]

{ #category : #actions }
MolComponentMemento >> save: aComponent [
]

{ #category : #'undo - undo' }
MolComponentMemento >> undo [

	
]
