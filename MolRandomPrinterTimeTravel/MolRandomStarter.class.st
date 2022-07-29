Class {
	#name : #MolRandomStarter,
	#superclass : #Object,
	#category : #MolRandomPrinterTimeTravel
}

{ #category : #'start-stop' }
MolRandomStarter class >> StartRandomPrinter [

	<script>
	MolRandomSenderImpl start.
	MolRandomReceiverImpl start
]

{ #category : #'start-stop' }
MolRandomStarter class >> StartRandomPrinterWithTimeTravel [

	<script>
	
	MolTimeTravel start.
	MolRandomSenderImpl start.
	MolRandomReceiverImpl start.
]

{ #category : #'start-stop' }
MolRandomStarter class >> StopRandomPrinter [

	<script>
	MolRandomSenderImpl stop.
	MolRandomReceiverImpl stop.
	MolComponentManager cleanUp
]
