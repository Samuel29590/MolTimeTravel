Class {
	#name : #MolGeneralMemento,
	#superclass : #MolComponentMemento,
	#instVars : [
		'variables',
		'reproducedVariables'
	],
	#category : #MolTimeTravel
}

{ #category : #accessing }
MolGeneralMemento >> getReproducedVariables [

	^ reproducedVariables
]

{ #category : #accessing }
MolGeneralMemento >> getVariables [

	^ variables
]

{ #category : #'undo - undo' }
MolGeneralMemento >> redo [

	reproducedVariables := OrderedCollection new.

	variables do: [ :var | 
		reproducedVariables add:
			var key -> var value timeTravelDecoder ].

	self restoreValues
]

{ #category : #actions }
MolGeneralMemento >> save: aComponent [

	| componentVariableNames |
	componentReference := MolComponentReference newFrom: aComponent.

	componentVariableNames := aComponent class slotNames.

	variables := OrderedCollection new.

	componentVariableNames do: [ :variableName | 
			| variableValue |
			variableValue := aComponent instVarNamed: variableName.
		(#componentName | #componentConnector = variableName) | (variableValue isProcess) ifFalse: [ 
				variables add: variableName -> variableValue timeTravelEncoder ] ]
]

{ #category : #'undo - undo' }
MolGeneralMemento >> undo [

	reproducedVariables := OrderedCollection new.

	variables do: [ :var | 
		reproducedVariables add: var key -> var value timeTravelDecoder ].

	self restoreValues
]
