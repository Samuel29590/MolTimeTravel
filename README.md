# MolAntsExperimental

This is the experimental version of [MolAnts](https://github.com/Samuel29590/MolAnts) for time-traveling.
This repository aims to help the search in Time-Traveling debugging techniques with component oriented programming.

## Getting Started

### Prerequisites

MolAntsExperimental require [Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and [Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.

### Installing MolAntsExperimental

Add the repository directly in Pharo thanks to the Iceberg.

## Documentation

MolAntsExperimental like [MolAnts](https://github.com/Samuel29590/MolAnts) is a simulation of an anthill, here the implementation of the anthill and entities are simplfy to test quickly. Futhermore, this version add the possibility of returning in the past, and replay the simulation step by step, it's called time-traveling.

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

### How is the data recorded ?

Data of the simulation are recorded following the [Momento Pattern](https://en.wikipedia.org/wiki/Memento_pattern), this application as been adapted to fit with components.

![TimeTravel_DataStorage](https://user-images.githubusercontent.com/64481702/176431453-dc1fa4e8-c242-49e6-b301-d262936b8744.png)

This is the component *TimeTravel* that store the history, in the variable *history*. This variable is an ordered collection of *MAComponentStep*. Each index of this collection represent the simulation state at on step (E.g. index 1 represent the state at step 0, index 2 represent the state at step 1, ...).

*MAComponentStep* is an object that aims to store the state of the simulation at one step. It has two variables, one to store data of components: *mementos*, and one to store creation or deletion of components: *creationsAndDeletions*. This two variables are ordered collections of *MAComponentMemento*'subclasses.

![MomentosOrganization](https://user-images.githubusercontent.com/64481702/176432080-bb5198c5-7f3d-4ffc-9040-adb59833ab8b.png)

So when a component is created or deleted from the simulation, the component create a *MAComponentCreationMemento* instance or a *MAComponentDeletionMemento* instance, and notify the component *TimeTravel* to store it. Then the component *TimeTravel* will look on the history to know if the step as already been created, if not it will create the *MAComponentsStep* associate to the step, and add it to the *history* collection. After that it will store the *MAComponentCreationMemento* instance or the *MAComponentDeletionMemento* instance on the variable *creationsAndDeletions* of the *MAComponentsStep*. From there, the creation or deletion has been saved.

For components state it is almost the same process. When a component is updated it will create a memento. The component *SimulationManager* will create a *MASimulationMemento*, the component *insect* will create a *MAInsectMemento*, the component *ant* will create a *MAAntMemento*. These three mementos are all subclasses of *MAComponentMemento*. The process to store them is almost the same as *creationsAndDeletions*, the component *TimeTravel* receive the notification to save the memento and look in the history to know if the step as already been created. After that it will store the *MAComponentMemento* on the variable *mementos*  of the *MAComponentsStep* associate to the step where the *MAComponentMemento* has been created. From there, the state of the component has been saved through its memento.

#### How to save reference of a component

For saving objects that are instances of component the process is a little different. Saving the reference of the instance isn't a good idea because components can be created or removed during the simulation, so the instances saved will refer to old component instances. The solution to solve this problem is quite simple, with [Molecule](https://github.com/OpenSmock/Molecule), component names are unique for each component types. It means that two different component with different type can have the same name, but two components with the same type can't have the same name. Thanks to this feature, a solution to solve the problem of saving component instances is to save the component class and the component name instead of the reference. From there if the component instance is stopped and restarted we don't have the problem of an incorrect instance. The process to restore the correct instance is simple, using *MolUtils* (a feature of [Molecule](https://github.com/OpenSmock/Molecule)), we are able to retrieve any component instance by specifying the component class and component name (*instanceOf: aClass named: aName*).

<br>

![collection_save](https://user-images.githubusercontent.com/64481702/175542288-49e089d1-a23c-4a98-8149-05f1ffc95e82.png)

<br>

### How is the data restored ?

The process to restore data is quite simple. The component *TimeTravel* examine the history that was saved, step-by-step, during the execution and restore the data by updating all the other components directly. The component *TimeTravel* also restore or remove components that appear or disappear during the simulation. With this two feature it's possible to play backward the simulation and to replay it step-by-step.

#### Creation and deletion of components

During undo, components created and deleted during the simulation are also undo. When we go back, the creations (*MAComponentCreationMemento*) are replayed as a deletion, and the deletions (*MAComponentDeletionMemento*) are replayed as a creation. With this behavior, when we go back we have the same components present in the simulation.

The specificity for creation and deletion during undo is that they are interpreted with a shift step. For example if we undo the step X , we will replay the creation and deletion of the step X+1. This specificity is necessary because if we interpret creation and deletion of the same step, we will create components that were not present during execution and delete components that were present during execution.

![undo](https://user-images.githubusercontent.com/64481702/176385748-186ad58b-ef82-4dfc-a226-33aaefacfe90.png)

In the case of redo, it's simpler, creations and deletions are replayed as they were recorded. A creation (*MAComponentCreationMemento*) is replayed as a creation, and a deletion (*MAComponentDeletionMemento*) is replayed as a deletion. Futhermore, when a component is recreated, its in-step state is also restored.

And in redo on the contrary with undo we interpret the creations and deletions of the same step which is restored (For example if we redo step X , we will replay the creation and deletion of step X).

![redo](https://user-images.githubusercontent.com/64481702/176385734-b2bc4b42-5df8-4f17-8deb-1dd444c43bfc.png)

#### Values of components

When we time travel on the simulation, the *TimeTravel* component will execute the *undo* or *redo* methods of the mementos at each restored step. These methods will tell the mementos to restore the variables of their associated component, using the *restorFrom: aMemento* method present in the components. The components receive the mementos and restore their variables using the values saved on the mementos.

#### Example of an undo and a restoration from a memento (example non exhaustive)

![RestoreDataSchema](https://user-images.githubusercontent.com/64481702/176444784-ee0004cf-9a7b-4bed-8c68-1b073e88570f.png)

<br><br><br>
<br><br><br>

## Illustrations

<img src="https://user-images.githubusercontent.com/64481702/175001208-438f7c33-f4a9-49ac-88fa-85e58d051d1a.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/175001226-4100de54-5faf-4234-ab44-508c80248062.png" width="50%">

<img src="https://user-images.githubusercontent.com/64481702/175001242-2a2d55f4-ea23-4bae-8e92-d5e07d72a8b5.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/175001261-fa80636e-97ff-413b-8cd7-be632148541b.png" width="50%">
