# MolAntsExperimental

This is the experimental version of [MolAnts](https://github.com/Samuel29590/MolAnts) for time-traveling.
This repository aims to help the search in Time-Traveling debugging techniques with component oriented programming.

## Getting Started

### Installing MolAntsExperimental

Add the repository directly in Pharo thanks to the Iceberg.

Pharo 8, Pharo 9 and Pharo 10 : 

(https://github.com/OpenSmock/MolAnts)

### Prerequisites

MolAntsExperimental require [Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and [Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.

## Documentation

MolAntsExperiment like [MolAnts](https://github.com/Samuel29590/MolAnts) is a simulation of an anthill, here the implementation of the anthill and entities are simplfy to test quickly. Futhermore, this version add the possibility of returning in the past, and replay the simulation step by step, it's called time-traveling.

### Components explanation

![TimeTravel-Component-UML](https://user-images.githubusercontent.com/64481702/174978742-26bc40b0-36aa-44f8-a480-4fffed527e26.png)

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
The ant component consumes the service of the *SimulationManager* to know positions of insects. And if an ant is close to an insect, the ant produce and event that is consumed by the *SimulatioManager* andthe insect die and the storage variable of the simulation increase.

#### TimeTravel

The component TimeTravel aims to store data about all the components of the simulation. So when components variables changes, this changes are recorded by the TimeTravel component.
With this data about components we are able to go backward on the simulation and replay step by step all the simulation.

The component *TimeTravel* is extrenal from the simulation, and all components consume its event and use its service. Its event permit to restore the state of an object at a particular step and to notify when the component is recording or time traveling. Its service permit for components to save their states, permit to get data about the component and permit to do action while time-traveling. 

### How is the data recorded ?

Data of the simulation are recorded following the [Momento Pattern](https://en.wikipedia.org/wiki/Memento_pattern), this application as been adapted to fit with components.

![TimeTravel_DataStorage](https://user-images.githubusercontent.com/64481702/174978677-4da7b82f-aef1-44a9-9cec-661b7a5c0e06.png)

This is the component *TimeTravel* that store the history, in the variable *history*. This variable is an ordered collection of *MAComponentsMementos*. Each index of this collection represent the simulation state at on step (E.g. index 1 represent the state at step 0, index 2 represent the state at step 1, ...).

*MAComponentsMementos* is an object that aims to store the state of the simulation at one step. It has two variables, one to store data of components: *mementos*, and one to store creation or deletion of components: *componentsLifeCycles*. This two variables are ordered collections of respetively: *MAComponentMemento*'subclasses and *MAComponentLifeCycleMemento*'s subclasses.

![MomentosOrganization](https://user-images.githubusercontent.com/64481702/174978694-3813a42e-69b7-4f95-a2d1-fbcb5e13f154.png)

So when a component is created or deleted from the simulation, the component create a *MAComponentCreationMemento* or a *MAComponentDeletionMemento*, and notify the component *TimeTravel* to store it. Then the component *TimeTravel* will look on the history to know if the step as already been created, if not it will create the *MAComponentsMementos* associate to the step, and add it to the *history* collection. After that it will store the *MAComponentLifeCycleMemento* on the variable *ComponentsLifeCycles* of the *MAComponentsMementos*. From there, the creation or deletion has been saved.

For components state it is almost the same process. When a component is updated it will create a memento. The component *SimulationManager* will create a *MASimulationMemento*, the component *insect* will create a *MAInsectMemento*, the component *ant* will create a *MAAntMemento*. These three mementos are all subclasses of *MAComponentMemento*. The process to store them is almost the same as *ComponentsLifeCycle*, the component *TimeTravel* receive the notification to save the memento and look in the history to know if the step as already been created. After that it will store the *MAComponentMemento* on the variable *mementos*  of the *MAComponentsMementos* associate to the step where the *MAComponentMemento* has been created. From there, the state of the component has been saved through its memento.

## Illustrations

<img src="https://user-images.githubusercontent.com/64481702/175001208-438f7c33-f4a9-49ac-88fa-85e58d051d1a.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/175001226-4100de54-5faf-4234-ab44-508c80248062.png" width="50%">

<img src="https://user-images.githubusercontent.com/64481702/175001242-2a2d55f4-ea23-4bae-8e92-d5e07d72a8b5.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/175001261-fa80636e-97ff-413b-8cd7-be632148541b.png" width="50%">
