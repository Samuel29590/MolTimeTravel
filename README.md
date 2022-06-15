# MolAnts

This is the experimental version on ![MolAnts](https://github.com/Samuel29590/MolAnts).

## Getting Started

### Installing MolAnts

Add the repository directly in Pharo thanks to the Iceberg.

Pharo 8, Pharo 9 and Pharo 10 : 

(https://github.com/OpenSmock/MolAnts)

### Prerequisites

MolAnts require ![Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and ![Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.
  
![TimeTravel](https://user-images.githubusercontent.com/64481702/173848990-10014350-4c89-4f85-b1fb-20c22705d9e1.png)

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
