"
This service is used by the ground and the ants. It describes methods that the simulation need to implement. Some of these methods permit to get information about the simulation. As all alive ants, insects positions and all pheromones positions and data. These data are used in the different implementations of ants to do consistent actions and in the ground to draw entities.

This service also describe two methods that the simulation need to implement: start/stop. And a variable: isRunning that the simulation implementation needs to keep up-to-date.

Variables :

-isRunning, is a Boolean that is set to true when the simulation is playing and set to false when it is paused or stopped.
"
Trait {
	#name : #TMASimulationServices,
	#instVars : [
		'isRunning'
	],
	#traits : 'MolComponentServices',
	#classTraits : 'MolComponentServices classTrait',
	#category : #MolAnts
}

{ #category : #services }
TMASimulationServices >> ants [

	
]

{ #category : #services }
TMASimulationServices >> feedingPoints [

	
]

{ #category : #services }
TMASimulationServices >> getPheromonesDict [
]

{ #category : #services }
TMASimulationServices >> getPheromonesReturnDict [
]

{ #category : #services }
TMASimulationServices >> insects [

	
]

{ #category : #services }
TMASimulationServices >> isRunning [

	^isRunning ifNil: [ isRunning := false ].
	
]

{ #category : #services }
TMASimulationServices >> start [
]

{ #category : #services }
TMASimulationServices >> step [

	
]

{ #category : #services }
TMASimulationServices >> stop [
]

{ #category : #services }
TMASimulationServices >> storage [

	
]
