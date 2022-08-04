# MolTimeTravel

This is an adaptation of time-traveling for [Molecule](https://github.com/OpenSmock/Molecule) (component oriented programming framework for [Pharo](https://pharo.org/)).

**⚠️** At the moment, MolTimeTravel only works on deterministic systems, because we cannot determine where the non-deterministic sources are at this time.

This repository aims to help the search in Time-Traveling debugging techniques with component oriented programming.

## Getting Started

### Prerequisites

MolTimeTravel require [Molecule](https://github.com/OpenSmock/Molecule) for the component aspect and [Bloc](https://github.com/pharo-graphics/Bloc) for the visual aspect.
So this is why this two frameworks are loaded with the baseline of MolTimeTravel.

### Installing MolTimeTravel

```smalltalk
Metacello new
        baseline: 'MolTimeTravel';
        repository: 'github://Samuel29590/MolTimeTravel';
        load.
```

## Documentation


If you want to know more about the examples loaded with MolTimeTravel : [MolAntsTimeTravel](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/MolAntsTimeTravel.md), [MolGPSTimeTravel](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/MolGPSTimeTravel.md) or [MolRandomPrinterTimeTravel](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/MolRandomPrinterTimeTravel.md), click on the hyperlink.

<br>

**⚠️** The following explanations may be outdated because work is still in progress on this repository. And some parts continue to evolve or to be remake

<br>

### How is the data recorded with the *TimeTravel* component ?

Data of the simulation are recorded following the [Momento Pattern](https://en.wikipedia.org/wiki/Memento_pattern), this application as been adapted to fit with components. 

Memento is a way of backing up components by backing up only the information that is needed to be able to restore it later. With this method we do not save the components but only their data.

**⚠️** this image needs to be redraw.
![TimeTravel_DataStorage](https://user-images.githubusercontent.com/64481702/176431453-dc1fa4e8-c242-49e6-b301-d262936b8744.png)

This is the component *TimeTravel* that store the history of the simulation, in the variable *history*. This variable is an ordered collection of *MAComponentStep*. Each index of this collection represent the application state at one step (E.g. index 1 represent the state at step 0, index 2 represent the state at step 1, ...).

*MAComponentStep* is an object that aims to store the state of the simulation at one step. It has seven variables : *mementos, creations, deletions activations, passivations, events* and *services*. These variables are nil or are ordered collections of *MAComponentMemento*'subclasses if they contain data.

A step in Moltimetravel can correspond to different actions that have taken place in the application. A new step is created as soon as there is an action in the application. These actions are: creations, deletions, activations, passivations, events or services. In addition, sometimes a backup of all components can be made, this also creates a new step.

**⚠️** this image needs to be redraw.
![MomentosOrganization drawio](https://user-images.githubusercontent.com/64481702/177515528-54842cc5-8aac-43e9-bcb5-112513b9003c.png)

#### Components recording

For the backup of the components of an application there are several possibilities, either there is a backup of a creation, deletion, activation or passivation of a component which means that all the components of the application are saved. Either there is a save of an event or a service and then the concerned component is saved before and after the event or service. Finally there is always the possibility that the developer indicates when a component should be saved or when the entire application should be saved. To save the entire application the service *saveTheApplication* provided by the MolTimeTravel component can be used. This service will send an event (*saveForTimeTravel*) to all the components of the simulation to save their state. Or each component of an application using time travel can use the *saveForTimeTravel* method which saves its state.

Each component of an applications using time travel has its own version of *saveForTimeTravel* but they all has the same behavior. The component will create a memento and use the service : *save: aComponentMemento*, provided by the *TimeTravel* component, to store the memento.

In the component **TimeTravel** the process to store them is almost the same for all the mementos (mementos, creations, deletions, activations, passivations, events, services). The component *TimeTravel* receive the notification to save the memento and look in the history to know if the step already contains this memento, if yes a new step is created, and after the component memento is send to the *MolComponentStep* to be saved in the variable *mementos*. From there, the state of the component has been saved through its memento.

##### How to save reference of a component

For saving variables of components that are or contain instances of component the process is a little different. Saving the reference of the instance isn't a good idea because components can be created or removed during the simulation, so the instances saved will refer to old component instances. The solution to solve this problem is quite simple, with [Molecule](https://github.com/OpenSmock/Molecule), component names are unique for each component types. It means that two different component with different type can have the same name, but two components with the same type can't have the same name. Thanks to this feature, a solution to solve the problem of saving component instances is to save the component class and the component name instead of the reference. From there if the component instance is stopped and restarted we don't have the problem of an incorrect instance. The process to restore the correct instance is simple, using *MolUtils* (a feature of [Molecule](https://github.com/OpenSmock/Molecule)), we are able to retrieve any component instance by specifying the component class and component name (*instanceOf: aClass named: aName*).
So when a variable of a component is or contains reference to an other component, we save it through a *MolComponentReference* wich is an object that store the class and the name of the component.

**⚠️** this image needs to be redraw.
![collection_save](https://user-images.githubusercontent.com/64481702/175542288-49e089d1-a23c-4a98-8149-05f1ffc95e82.png)

#### Creations and deletions recording

So when a component is created or deleted from the simulation, the component create a *MAComponentCreationMemento* instance or a *MAComponentDeletionMemento* instance, and notify the component *TimeTravel* to store it. Then the component *TimeTravel* will look on the history to know if the step as already been created, if not it will create the *MAComponentsStep* associate to the step, and add it to the *history* collection. After that it will store the *MAComponentCreationMemento* instance or the *MAComponentDeletionMemento* instance on the variable *creationsAndDeletions* of the *MAComponentsStep*. From there, the creation or deletion has been saved.

#### Activations and passivations recording


#### Events recording

#### Services recording

<br>

### How is the data restored ?

The process to restore data is quite simple. The component *TimeTravel* examine the history that was saved, step-by-step, during the execution and restore the data by updating all the other components directly. The component *TimeTravel* also restore or remove components that appear or disappear during the simulation. With this two feature it's possible to play backward the simulation and to replay it step-by-step.

#### Creation and deletion of components

During undo, components created and deleted during the simulation are also undo. When we go back, the creations (*MAComponentCreationMemento*) are replayed as a deletion, and the deletions (*MAComponentDeletionMemento*) are replayed as a creation. With this behavior, when we go back we have the same components present in the simulation.

The specificity for creation and deletion during undo is that they are interpreted with a shift step. For example if we undo the step X , we will replay the creation and deletion of the step X+1. This specificity is necessary because if we interpret creation and deletion of the same step, we will create components that were not present during execution and delete components that were present during execution.
<br>*If you want to know more about this specificity click here : [undoProblem](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/undoProblem.md).*

![undo](https://user-images.githubusercontent.com/64481702/176385748-186ad58b-ef82-4dfc-a226-33aaefacfe90.png)

<br>
In the case of redo, it's simpler, creations and deletions are replayed as they were recorded. A creation (*MAComponentCreationMemento*) is replayed as a creation, and a deletion (*MAComponentDeletionMemento*) is replayed as a deletion.

And in redo on the contrary with undo we interpret the creations and deletions of the same step which is restored (For example if we redo step X , we will replay the creation and deletion of step X).

![redo](https://user-images.githubusercontent.com/64481702/176385734-b2bc4b42-5df8-4f17-8deb-1dd444c43bfc.png)

#### Values of components

When we time travel on the simulation, the *TimeTravel* component will execute the *undo* or *redo* methods of the mementos at each restored step. These methods will tell the mementos to restore the variables of their associated component, using the *restorFrom: aMemento* method present in the components. The components receive the mementos and restore their variables using the values saved on the mementos.

#### Example of an undo and a restoration from a memento (example non exhaustive)(example on MolAntsTimeTravel)

![RestoreDataSchema](https://user-images.githubusercontent.com/64481702/177521067-61e1f0ad-5454-4f1e-a0cc-2d5e12de7874.png)

<br><br><br>

### How is the Time Travel implemented ?

If you want to know how time travel is implemented in the simulation and what are the steps to follow to make it go, see this document: [9 steps to implement TimeTravel in MolAnts](https://github.com/Samuel29590/MolAntsTimeTravel/blob/master/ImplementationOfTimeTravel.md)

<br><br><br>

## Illustrations

<img src="https://user-images.githubusercontent.com/64481702/182809344-0d3c1ca8-7798-463c-814a-bb4b3f6730ef.png" width="33%"><img src="https://user-images.githubusercontent.com/64481702/182809352-9c755768-2b59-4039-b826-63354c33722e.png" width="33%"><img src="https://user-images.githubusercontent.com/64481702/182809357-1457329f-7716-488c-8f19-b646ae8b386e.png" width="33%">
