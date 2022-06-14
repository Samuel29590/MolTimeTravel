Class {
	#name : #MATimeTravelExperimental,
	#superclass : #Object,
	#traits : 'MolComponentImpl + TMATimeTravelExperimentalType',
	#classTraits : 'MolComponentImpl classTrait + TMATimeTravelExperimentalType classTrait',
	#instVars : [
		'history'
	],
	#category : #MolAntsExperimental
}

{ #category : #'life cycle' }
MATimeTravelExperimental >> componentInitialize [

	"here write the code corresponding to component initialisation phase"

	history := Dictionary new.
]

{ #category : #'life cycle' }
MATimeTravelExperimental >> componentRemove [

	"here write the code corresponding to component remove phase"

	history := nil.
]
