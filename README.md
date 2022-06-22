# MolAntsExperimental

This is the experimental version of ![MolAnts](https://github.com/Samuel29590/MolAnts) for time-traveling.
This repository aims to help the search in Time-Traveling debugging techniques with component oriented programming.

## Getting Started

### Installing MolAntsExperimental

Add the repository directly in Pharo thanks to the Iceberg.

Pharo 8, Pharo 9 and Pharo 10 : 

(https://github.com/OpenSmock/MolAnts)

### Prerequisites

MolAntsExperimental require ![Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and ![Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.

## Documentation

MolAntsExperiment like ![MolAnts](https://github.com/Samuel29590/MolAnts) is a simulation of an anthill, here the implementation of the anthill and entities are simplfy to test quickly. Futhermore, this version add the possibility of returning in the past, and replay the simulation step by step, it's called time-traveling.

### Components explanation

#### Simulation

The component *SimulationManager* is the manager of the simulation it contains the main loop of the system. This loop send the simulationStepSend event message to each entity at each turn.
This implementation provides start / pause / play / stop methods on the class side.

#### Ground

The component *Ground* is the implementation of the system's view. It permits to draw all the entities of the system on a canvas and to keep the information panel up-to-date. It also permits to have a functional interface with buttons to start, pause and stop the system.
Futhermore, it also provide the time-travel panel.

#### Insects

The component insect is very simple, insects spawn randomly on the ground and move randomly on the ground waiting to be eaten.

#### Ants

The component ant. Ants spawn in the of the ground and move also randomly on the ground. If an ant is close to an insect, the insect die and the storage variable of the simulation increase.

#### TimeTravel

The component TimeTravel aims to store data about all the components of the simulation. So when components variables changes, this changes are recorded by the TimeTravel component.
With this data about components we are able to go backward on the simulation and replay step by step all the simulation.

### How is the data recorded ?

![TimeTravel_DataStorage](https://user-images.githubusercontent.com/64481702/174978677-4da7b82f-aef1-44a9-9cec-661b7a5c0e06.png)

![MomentosOrganization](https://user-images.githubusercontent.com/64481702/174978694-3813a42e-69b7-4f95-a2d1-fbcb5e13f154.png)

Data of the simulation are recorded following the ![Momento Pattern](https://en.wikipedia.org/wiki/Memento_pattern), this application as been adapted to fit with components.

### UML of the components, events and services of MolAntsExperimental

![TimeTravel-Component-UML](https://user-images.githubusercontent.com/64481702/174978742-26bc40b0-36aa-44f8-a480-4fffed527e26.png)
