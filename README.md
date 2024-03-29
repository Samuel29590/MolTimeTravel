# MolTimeTravel

MolTimeTravel is an adaptation of time-traveling for [Molecule](https://github.com/OpenSmock/Molecule) (a component oriented programming framework for [Pharo](https://pharo.org/)).

**⚠️** MolTimeTravel only works on deterministic systems, because for the moment we cannot determine where the non-deterministic sources are.

This repository aims to help the search in Time-Traveling debugging techniques with component oriented programming.

<br>

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
### Tutorial / user guide

If you want to know how to add time travel to a Molecule system, look at this document: [Steps to make TimeTravel work in a Molecule system](https://github.com/Samuel29590/MolAntsTimeTravel/blob/master/ImplementationOfTimeTravel.md)

<br>

## Documentation

If you want to know more about the examples loaded with MolTimeTravel : [MolAntsTimeTravel](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/MolAntsTimeTravel.md), [MolGPSTimeTravel](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/MolGPSTimeTravel.md) or [MolRandomPrinterTimeTravel](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/MolRandomPrinterTimeTravel.md), click on the hyperlink.

**⚠️** The following explanations may be outdated because work is still in progress on this repository. And some parts continue to evolve or to be remake

### How is the data recorded with the *TimeTravel* component ?

Data of the simulation are recorded following the [Momento Pattern](https://en.wikipedia.org/wiki/Memento_pattern), this pattern as been adapted to fit with components. 

Memento is a way of backing up components by backing up only the information that is needed to be able to restore it later. With this method we do not save the components but only their data.

![TimeTravel_DataStorage](https://user-images.githubusercontent.com/64481702/183430634-fafce9f8-7202-43c9-a957-346c07deb8de.png)

This is the component *TimeTravel* that store the history of the simulation, in the variable *history*. This variable is an ordered collection of *MAComponentStep*. Each index of this collection represent the application state at one step (E.g. index 1 represent the state at step 0, index 2 represent the state at step 1, ...).

*MAComponentStep* is an object that aims to store the state of the simulation at one step. It has seven variables : *mementos, creations, deletions activations, passivations, events* and *services*. These variables are nil or are ordered collections of *MAComponentMemento*'subclasses if they contain data.

A step in *MolTimeTravel* can correspond to different actions that have taken place in the application. A new step is created as soon as there is an action in the application. These actions are: creations, deletions, activations, passivations, events or services. In addition, sometimes a backup of all components can be made, this also creates a new step.

![Mementos_Steps](https://user-images.githubusercontent.com/64481702/184111587-9e70bc42-e89c-4ed8-b6e4-6480ba4e8a80.png)

#### Components recording

For the backup of the components of an application there are several possibilities, either there is a backup of a creation, deletion, activation or passivation of a component which means that all the components of the application are saved. Either there is a save of an event or a service and then the concerned component is saved before and after the event or service. Finally there is always the possibility that the developer indicates when a component should be saved or when the entire application should be saved. To save the entire application the service *saveTheApplication* provided by the MolTimeTravel component can be used. This service will send an event (*saveForTimeTravel*) to all the components of the simulation to save their state. Or each component of an application using time travel can use the *saveForTimeTravel* method which saves its state.

Each component of an applications using time travel has its own version of *saveForTimeTravel* but they all has the same behavior. The component will first create a memento and then use the service : *save: aComponentMemento*, provided by the *TimeTravel* component, to store the memento.

In the component **TimeTravel** the process to store a component memento is almost the same for all the mementos (component status, creations, deletions, activations, passivations, events, services). The component *TimeTravel* receive the notification to save the memento and look in the history to know if the step already contains this memento, if yes a new step is created, after the component memento is send to the *MolComponentStep* to be saved in the variable *mementos*. From there, the state of the component has been saved through its memento.

##### How to save reference of a component

For saving variables of components that are or contain instances of component the process is a little different from a normal variable. Saving the reference of the instance isn't a good idea because components can be created or removed during the simulation, so the instances saved will refer to old component instances. The solution to solve this problem is quite simple, with [Molecule](https://github.com/OpenSmock/Molecule), component names are unique for each component types. It means that two different component with different type can have the same name, but two components with the same type can't have the same name. Thanks to this feature, a solution to solve the problem of saving component instances is to save the component class and the component name instead of the reference. From there if the component instance is stopped and restarted we don't have the problem of an incorrect instance. The process to restore the correct instance is simple, using *MolUtils* (a feature of [Molecule](https://github.com/OpenSmock/Molecule)), we are able to retrieve any component instance by specifying the component class and component name (*instanceOf: aClass named: aName*).
So when a variable of a component is or contains reference to an other component, we save it through a *MolComponentReference* wich is an object that store the class and the name of the component reference.

![MolComponentReference(1)](https://user-images.githubusercontent.com/64481702/182854616-a2d72134-71ef-4b6e-a928-d107b3dc86d8.png)

<br>

#### Creations and deletions recording

When a component is created or deleted, the component notifies the *TimeTravel* component to store it using the ***creationOf:*** or ***deletionOf:*** service provided by the *TimeTravel* component . Then the *TimeTravel* component will look at its *history* variable to see if the current step is an empty step, otherwise it will create a new step. Next, the *TimeTravel* component creates an instance of *MAComponentCreationMemento* or an instance of *MAComponentDeletionMemento*. After that, it stores this instance in the *creations* variable or the *deletions* variable of *MAComponentsStep*. In addition, a backup of all application components is performed. From there, the creation or deletion was saved.

#### Activations and passivations recording

When a component is activated or passivated, the component creates an instance of *MAComponentActiveMemento* or an instance of *MAComponentPassiveMemento*, and notifies the component *TimeTravel* to store it. Then the *TimeTravel* component will look at its *history* variable to see if the current step is an empty step, otherwise it will create a new step. After that, it stores the *MAComponentActiveMemento* instance or the *MAComponentPassiveMemento* instance in the *activations* variable or the *passivations* variable of the *MAComponentsStep*. In addition, a backup of all application components is performed. From there, the activation or passivation was recorded. <br>
**❗** Activations and passivations performed when creating or deleting a component are not recorded by the TimeTravel. This is not necessary because a created component will always be directly activated and a deleted component will always be passivated before being deleted.

#### Events recording

When an event is consumed by a component, this component notifies the *TimeTravel* component that this event has occurred, in order to save it. To notify, the component uses ***saveEvent: aMethodName performBy: aComponent withParameters: someParameters needToReplay: aBoolean*** which is a service of the TimeTravel component. With this method, the *TimeTravel* component saves the state of the component before the event, then creates an instance of *MAComponentEventMemento* which can store event data like method name and parameters. This instance will be stored at the same step as the state before the event. Finally, the *TimeTravel* component saves the state of the component after the event on another step. From there the event is saved.

#### Services recording

When an service is provided by a component, this component notifies the *TimeTravel* component that this service has occurred, in order to save it. To notify, the component uses ***saveService: aMethodName performBy: aComponent withParameters: someParameters needToReplay: aBoolean*** which is a service of the TimeTravel component. With this method, the *TimeTravel* component saves the state of the component before the service, then creates an instance of *MAComponentServiceMemento* which can store service data like method name and parameters. This instance will be stored at the same step as the state before the event. From there the service is saved.

<br>

### How is the data restored ?

The data restoration process is quite simple. The *TimeTravel* component examines the history that was saved at runtime and restores the application state step by step. The *TimeTravel* component restores or deletes the components which appear or disappear during the simulation, activates and passives the components as during the first execution, restores the data of the components by directly changing their variables and finally replays the events and services if they must be replayed. Thanks to these features, it is possible to replay the simulation and replay it step by step.

#### Creation and deletion of components

During undo, components created and deleted during the execution are also undo. When we go back, the creations (*MAComponentCreationMemento*) are replayed as a deletion, and the deletions (*MAComponentDeletionMemento*) are replayed as a creation. With this behavior, when we go back we have the same components present in the simulation.

The specificity of creation and deletion on undo is that they are interpreted with an offset step. For example, if step X is canceled, the creation and deletion of step X+1 will be replayed. This specificity is necessary because if we interpret creation and deletion of the same step, we will create components that were not present during execution and delete components that were present during execution. Also, if the creations and deletions were played at their stage when undone and the direction of time travel changes for a replay, the creations and deletions at the stage of the change would not be played.
<br>*If you want to know more about this specificity click here : [undoProblem](https://github.com/Samuel29590/MolAntsTimeTravel/blob/main/undoProblem.md).*
![undo](https://user-images.githubusercontent.com/64481702/176385748-186ad58b-ef82-4dfc-a226-33aaefacfe90.png)

<br>
In the case of redo, it's simpler, creations and deletions are replayed as they were recorded. A creation (*MAComponentCreationMemento*) is replayed as a creation, and a deletion (*MAComponentDeletionMemento*) is replayed as a deletion.

And in redo on the contrary with undo we interpret the creations and deletions of the same step which is restored (For example if we redo step X , we will replay the creation and deletion of step X).

![redo](https://user-images.githubusercontent.com/64481702/176385734-b2bc4b42-5df8-4f17-8deb-1dd444c43bfc.png)

#### Activation and passivation of components

This is exactly the same process as for creations and deletions.
During the undo, the activations are played in passivation and the passivations in activations, with always a shift step.
And for the redo, no change just a replay.

#### Values of components

When we time travel on the simulation, the *TimeTravel* component will execute the *undo* or *redo* methods of the mementos at each restored step. These methods will tell the mementos to restore the variables of their associated component, using the *restorFrom: aMemento* method present in the components. The components receive the mementos and restore their variables using the values saved on the mementos.

##### Example of an undo and a restoration from a memento (example non exhaustive)(example on MolAntsTimeTravel)

![RestoreDataSchema](https://user-images.githubusercontent.com/64481702/177521067-61e1f0ad-5454-4f1e-a0cc-2d5e12de7874.png)

#### Replay of events and services

When saving events and services, it is indicated whether they should be replayed or not during the time travel.
If they are not replayed then during the undo and redo nothing is done.
But if they must be replayed then we first restore the state of the component before the event or the service and then we execute it using the method *perform: withArguments:*. And if it's an undo, we restore another time the state of the component before the event/service. If it is a redo, the next step contains the state after the event so that it is restored.

<br><br><br>

### How is the Time Travel implemented ?

### Creation of components

To record creation of components, the following code as been added directly to Molecule in MolHomeServices, where component are created.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182857469-ed42d144-001b-4935-b142-a87834e28def.png" width="75%">

### Deletion of components

To record deletion of components, the following code as been added directly to Molecule in MolHomeServices, where component are removed.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182857487-6f622c0a-dd79-4b73-9646-18e5eeac6863.png" width="75%">

### Activation of components

To record activation of components, the following code as been added directly to Molecule in MolHomeServices, where component are activate.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182858848-fe3755db-e9bf-49da-bff4-e910626054f1.png" width="75%">

### Passivation of components

To record passivation of components, the following code as been added directly to Molecule in MolHomeServices, where component are passivate.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182858833-c374bfde-a605-4a7b-8e43-317c5720bded.png" width="75%">

### Events and Services recording

Currently, events and services must be backed up manually. There is not yet a mechanism that allows as for creations or other to have the code generalized and written in Molecule and not in each event or service.

 ###### Example:
<img src="https://user-images.githubusercontent.com/64481702/183880154-08abebb5-e5b7-4ed3-9f8d-3e731694ca19.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/183880158-58ffc387-71f2-4f7c-9804-cc52e76aee97.png" width="50%">

<br><br>

## Illustrations

<img src="https://user-images.githubusercontent.com/64481702/182809344-0d3c1ca8-7798-463c-814a-bb4b3f6730ef.png" width="33%"><img src="https://user-images.githubusercontent.com/64481702/182809352-9c755768-2b59-4039-b826-63354c33722e.png" width="33%"><img src="https://user-images.githubusercontent.com/64481702/182809357-1457329f-7716-488c-8f19-b646ae8b386e.png" width="33%">
