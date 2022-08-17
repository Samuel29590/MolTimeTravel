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

	variables do: [:var |
		reproducedVariables add: ((var key)->(self reproduceInDepth: (var value))).
		
		].
	
	self restoreValues.
]

{ #category : #actions }
MolGeneralMemento >> reproduceInDepth: aVariable [

		self flag:'This method will probably have to be replaced in the future.'.
	
	aVariable isAssociation ifTrue: [ ^((self reproduceInDepth: aVariable key)->(self reproduceInDepth: aVariable value)) ].

	aVariable isDictionary ifTrue: [ |variableTemp |
		variableTemp := aVariable class new.
		aVariable keysAndValuesDo: [ :k :v | variableTemp add: ((self reproduceInDepth: k)->(self reproduceInDepth: v)) ].
		^ variableTemp 
	].

	aVariable isCollection ifTrue: [ |variableTemp |
		variableTemp := aVariable class new.
		aVariable do: [:v | variableTemp add: (self reproduceInDepth: v) ].
		^ variableTemp 
	].

	aVariable isComponentReference ifTrue: [ ^ (MolUtils instanceOf: aVariable componentClass named: aVariable componentName) ].
	^ aVariable
]

{ #category : #actions }
MolGeneralMemento >> save: aComponent [
	
	| componentVariableNames |
	componentReference := MolComponentReference newFrom: aComponent.

	componentVariableNames := aComponent class slotNames.

	variables := OrderedCollection new.

	componentVariableNames do: [ :variableName | 
		| variableValue |
		variableName = #componentName ifFalse: [ 
			variableName = #componentConnector ifFalse: [ 
				variableValue := aComponent instVarNamed: variableName.
				(variableValue isKindOf: Process) ifFalse: [ 
					variables add: variableName -> (self saveInDepth: variableValue) ] ] ] ].
	
		self flag:
		'This method will probably have to be replaced in the future.'.
]

{ #category : #actions }
MolGeneralMemento >> saveInDepth: aVariable [

	self flag:
		'This method will probably have to be replaced in the future.'.

	aVariable isAssociation ifTrue: [ 
		^ (self saveInDepth: aVariable key)
		  -> (self saveInDepth: aVariable value) ].

	aVariable isDictionary ifTrue: [ 
		| variableTemp |
		variableTemp := aVariable class new.
		aVariable keysAndValuesDo: [ :k :v | 
			variableTemp add: (self saveInDepth: k) -> (self saveInDepth: v) ].
		^ variableTemp ].

	aVariable isCollection ifTrue: [ 
		| variableTemp |
		variableTemp := aVariable class new.
		aVariable do: [ :v | variableTemp add: (self saveInDepth: v) ].
		^ variableTemp ].

	aVariable isComponent ifTrue: [ 
		^ MolComponentReference newFrom: aVariable ].
	^ aVariable
]

{ #category : #'undo - undo' }
MolGeneralMemento >> undo [

	reproducedVariables := OrderedCollection new.

	variables do: [:var |
		reproducedVariables add: ((var key)->(self reproduceInDepth: (var value))).
		
		].
	
	self restoreValues
]
