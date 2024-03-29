Class {
	#name : #MolRandomReceiverMemento,
	#superclass : #MolComponentMemento,
	#category : #MolRandomPrinterTimeTravel
}

{ #category : #'undo - undo' }
MolRandomReceiverMemento >> redo [

	self restoreValues.
]

{ #category : #'undo - undo' }
MolRandomReceiverMemento >> save: aGround [

	componentReference := MolComponentReference newFrom: aGround.
]

{ #category : #'undo - undo' }
MolRandomReceiverMemento >> undo [

	self restoreValues
]
