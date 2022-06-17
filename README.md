# MolAnts

This is the experimental version on ![MolAnts](https://github.com/Samuel29590/MolAnts).

## Getting Started

### Installing MolAnts

Add the repository directly in Pharo thanks to the Iceberg.

Pharo 8, Pharo 9 and Pharo 10 : 

(https://github.com/OpenSmock/MolAnts)

### Prerequisites

MolAnts require ![Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and ![Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.

### Documentation

##### How is the data recorded ?

![TimeTravel_DataStorage](https://user-images.githubusercontent.com/64481702/174248508-3057c45c-e5c0-42b7-8cf9-c76935b9d547.png)

Each time a component is modified, the component uses the *TMATimeTravelServices* and the *save: aComponent at: aStep* method to save its data at this stage of the simulation.

The data are stored in the dictionary: *history* of the compinent *TimeTravel*. This dictionary has the simulation step as its key and another dictionary as its value which contains all the data on the simulation components. Thus, for each component, the data is stored in ordered collections to be able to retrieve them when we replay the simulation.

<br><br><br><br>

##### UML of the components, events and 

![TimeTravel](https://user-images.githubusercontent.com/64481702/174041805-89c3dc86-ed19-4990-b42a-bb5d27483647.png)

<br><br><br><br>

## Simulation

The component SimulationManager is the manager of the simulation it contains the main loop of the system. This loop send the simulationStepSend event message to each entity at each turn.

This implementation provides start / pause / play / stop methods on the class side.

<br><br><br><br>

## Insects

The component insect is very simple, insects spawn randomly on the ground and move randomly on the ground.

<br><br><br><br>

## Ants

The component ant. Ants spawn in the of the ground and move also randomly on the ground.

<br><br><br><br>

## Ground

The actual implementation of the *TMAGroundType*: *MAGround* is the implementation of the system's view. It permits to draw all the entities of the system on a canvas and to keep the information panel up-to-date. It also permits to have a functional interface with buttons to start, pause and stop the system.
Futhermore, it also 

<br><br><br><br>

## TimeTravel

The component TimeTravel aims to store data about all the components of the simulation. So when components variables changes, this changes are stored on the TimeTravel component.
With this data about components we are able to go backward on the simulation and replay step by step all the simulation.
