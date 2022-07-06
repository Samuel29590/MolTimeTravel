### Components explanation

![TimeTravel-Component-UML](https://user-images.githubusercontent.com/64481702/176172623-98fdb9da-cf8c-4d1c-911a-a47f8cff7924.png)

#### Simulation

The component *SimulationManager* is the manager of the simulation it contains the main loop of the system and data about the simulation as: number of ants, number of insect, insects positions, step ... 

The component *SimulationManager* provide one service, that permit to the other components to get access on simulation's data. And produce one event that is consumed by all the other components. In this event there is the method *simulationStepSend* that components of the simulation consumes to do their actions.

#### Ground

The component *Ground* is the implementation of the system's view. It permits to draw all the entities of the system on a canvas and to keep the information panel up-to-date. It also permits to have a functional interface with buttons to start, pause and stop the system.
Futhermore, it also provide the time-travel panel. To get data about the simulation, the view consumes the *SimulationManager* service. The view is update on a different thread from the simulation. 

#### Insects

The component insect is very simple, insects spawn randomly on the ground and move randomly on the ground waiting to be eaten. At each move the insect produce an event that the *SimulationManager* consumes to update the insect position.

#### Ants

Ants spawn in the middle of the ground and move randomly on the ground. 
The ant component consumes the service of the *SimulationManager* to know positions of insects. And if an ant is close to an insect, the ant produce and event that is consumed by the *SimulatioManager* and the insect die and the storage variable of the simulation increase.

#### TimeTravel

The component TimeTravel aims to store data about all the components of the simulation. So when components variables changes, this changes are recorded by the TimeTravel component.
With this data about components we are able to go backward on the simulation and replay step by step all the simulation.

The component *TimeTravel* is extrenal from the simulation, and all components consume its event and use its service. Its event permit to restore the state of an object at a particular step and to notify when the component is recording or time traveling. Its service permit for components to save their states, to get data about the component and permit to do action while time-traveling. 
