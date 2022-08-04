# Steps to implement TimeTravel in MolAnts


### 1 : Connect the component TimeTravel to all the other components

Every component of the simulation needs to be connected to the *TimeTravel* component and to do this, every component need to be added as consumer of the ***MATimeTravelEvent*** and user of the ***MATimeTravelService***.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/177966390-88d9a005-b82b-4749-bac3-d3694ba84971.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/177966403-d8b9d18f-9c2d-4aa9-be10-b49894e59d60.png" width="50%">

### 2 : Accessors

Each variable that is going to be saved must have an accessor. This accessor will be used by the memento associated to the component.

### 3 : Creation of the mementos

For each component that will be saved, you must create the memento that will be associated with it. This memento will describe the variables that will be saved and how they are saved.

<img src="https://user-images.githubusercontent.com/64481702/177966359-60fd8272-072d-4ec2-9783-51ee0b14daf3.png" width="75%">

### 4 : Recording method

Each component must describe the *saveForTimeTravel: aStep* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This is the creation of the memento and its save.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/177968018-e3dfc60a-dd21-43ce-863b-69665ed344d1.png" width="75%">

### 5 : Restoration method

Each component must describe the *restoreFrom: aMemento* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This involves restoring the state of a component for a step thanks to its memento for this step.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/177967447-50cf701c-6964-4f51-98ef-da7964203726.png" width="75%">

### 6 : Creation of components

To record creation of components, the following code as been added directly to Molecule in MolHomeServices, where component are created.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182857469-ed42d144-001b-4935-b142-a87834e28def.png" width="75%">

### 7 : Deletion of components

To record deletion of components, the following code as been added directly to Molecule in MolHomeServices, where component are removed.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182857487-6f622c0a-dd79-4b73-9646-18e5eeac6863.png" width="75%">

### 8 : Activation of components

To record activation of components, the following code as been added directly to Molecule in MolHomeServices, where component are activate.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182858848-fe3755db-e9bf-49da-bff4-e910626054f1.png" width="75%">

### 9 : Passivation of components

To record passivation of components, the following code as been added directly to Molecule in MolHomeServices, where component are passivate.

###### Code in Molecule:
<img src="https://user-images.githubusercontent.com/64481702/182858833-c374bfde-a605-4a7b-8e43-317c5720bded.png" width="75%">

### 10 : Know where to save the simulation at a step

Know where to put the call to the method *saveTheSimulationAt: aStep* which allows to tell all the components to save themselves for this step.

In MolAnts this call is placed in the main execution loop, at the end of each iteration.

<img src="https://user-images.githubusercontent.com/64481702/177966768-cd36972c-4d5a-4cb1-8883-17a384365b4c.png" width="75%">

### 11 : Know where to pause and play 

Knowing where the simulation breakpoints must be placed so that when the time travel begins, the simulation is paused. And when we stop the time travel the simulation play.

In MolAnts the management of the pause is carried out in the main loop, thanks to a condition on a variable of the *TimeTravel* component.

<img src="https://user-images.githubusercontent.com/64481702/177967001-f4effbec-1174-4f72-9362-8c1dfb0a212f.png" width="75%">
