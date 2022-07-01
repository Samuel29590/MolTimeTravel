Class {
	#name : #MAComponentMementoExperimental,
	#superclass : #Object,
	#instVars : [
		'componentClass',
		'componentName'
	],
	#category : #MolAntsExperimental
}

{ #category : #accessing }
MAComponentMementoExperimental >> componentClass [

	^ componentClass
]

{ #category : #accessing }
MAComponentMementoExperimental >> componentName [

	^ componentName
]

{ #category : #'undo - undo' }
MAComponentMementoExperimental >> redo [
]

{ #category : #accessing }
MAComponentMementoExperimental >> restoreValues [
 | instance |
	instance := (MolUtils instanceOf: componentClass named: componentName) .
	instance ifNotNil: [ instance restoreFrom: self. ]
]

{ #category : #actions }
MAComponentMementoExperimental >> save: aComponent [
]

{ #category : #'undo - undo' }
MAComponentMementoExperimental >> undo [

	
]
