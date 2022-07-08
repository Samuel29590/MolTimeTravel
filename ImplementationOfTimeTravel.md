# 10 steps to implement TimeTravel in MolAnts


### 1 : Connect the component TimeTravel to all the other components

Every component of the simulation needs to be connected to the *TimeTravel* component and to do this, every component need to be added as consumer of the ***MATimeTravelEvent*** and user of the ***MATimeTravelService***.

<img src="https://user-images.githubusercontent.com/64481702/177966390-88d9a005-b82b-4749-bac3-d3694ba84971.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/177966403-d8b9d18f-9c2d-4aa9-be10-b49894e59d60.png" width="50%">

### 2 : Accessors

Each variable that is going to be saved must have an accessor. This accessor will be used by the memento associated to the component.

### 3 : Creation of the mementos

For each component that will be saved, you must create the memento that will be associated with it. This memento will describe the variables that will be saved and how they are saved.

<img src="https://user-images.githubusercontent.com/64481702/177966359-60fd8272-072d-4ec2-9783-51ee0b14daf3.png" width="75%">

### 4 : Recording method

Each component must describe the *saveForTimeTravel: aStep* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This is the creation of the memento and its save.

<img src="https://user-images.githubusercontent.com/64481702/177968018-e3dfc60a-dd21-43ce-863b-69665ed344d1.png" width="75%">

### 5 : Restoration method

Each component must describe the *restoreFrom: aMemento* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This involves restoring the state of a component for a step thanks to its memento for this step.

<img src="https://user-images.githubusercontent.com/64481702/177967447-50cf701c-6964-4f51-98ef-da7964203726.png" width="75%">

### 6 : Creation of components

In the methods *componentInitialize* of each component, it is necessary to add the sends to the component *TimeTravel* of the creation of the component.

<img src="https://user-images.githubusercontent.com/64481702/177967312-c99015e4-21dd-4c8c-8717-26726d22c942.png" width="75%">

### 7 : Deletion of components

In the methods *componentRemove* of each component, it is necessary to add the sends to the component *TimeTravel* of the deletion of the component.

<img src="https://user-images.githubusercontent.com/64481702/177967762-95569d21-7c59-4855-855a-33a6a8246af0.png" width="75%">

### 8 : Know where to save the simulation at a step

Know where to put the call to the method *saveTheSimulationAt: aStep* which allows to tell all the components to save themselves for this step.

In MolAnts this call is placed in the main execution loop, at the end of each iteration.

<img src="https://user-images.githubusercontent.com/64481702/177966768-cd36972c-4d5a-4cb1-8883-17a384365b4c.png" width="75%">

### 9 : Know where to pause and play 

Knowing where the simulation breakpoints must be placed so that when the time travel begins, the simulation is paused. And when we stop the time travel the simulation play.

In MolAnts the management of the pause is carried out in the main loop, thanks to a condition on a variable of the *TimeTravel* component.

<img src="https://user-images.githubusercontent.com/64481702/177967001-f4effbec-1174-4f72-9362-8c1dfb0a212f.png" width="75%">

### 10 : Add the Time Travel panel

Added time travel buttons to the UI and made them work.

In MolAnts the interface is added to that of the simulation, but it could be separated.

<img src="https://user-images.githubusercontent.com/64481702/177966439-15ac7a56-ff53-4056-bdf0-7913547b48d6.png" width="75%">
