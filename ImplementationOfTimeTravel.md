# Steps to make TimeTravel work in a Molecule system

### 1 : Connect the component TimeTravel to all the other components

Every component of the simulation needs to be connected to the *TimeTravel* component and to do this, every component need to be added as consumer of the ***TimeTravelEvent*** and user of the ***TimeTravelService***.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/183368903-55c4ac56-94cd-45b4-acd3-324f9809adc0.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/183368802-8decb985-f805-4cb6-add8-4bf83bcec450.png" width="50%">

### 2 : Know where to pause and play 

Knowing where the simulation breakpoints must be placed so that when the time travel begins, the simulation is paused. And when we stop the time travel the simulation play.

In MolAnts the management of the pause is carried out in the main loop, thanks to a condition on a variable of the *TimeTravel* component.

<img src="https://user-images.githubusercontent.com/64481702/183370729-22868104-127a-41a5-a6aa-0642d216bf5a.png" width="75%">

### 3 : Record events and services

For each event or service of the system it is necessary to add the code below in the examples. For the moment this process is not automated and therefore remains to be done manually...

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/183880154-08abebb5-e5b7-4ed3-9f8d-3e731694ca19.png" width="50%"><img src="https://user-images.githubusercontent.com/64481702/183880158-58ffc387-71f2-4f7c-9804-cc52e76aee97.png" width="50%">

<br><br>

## The following steps are not mandatory, but allow to have better performance

### Create mementos specific to each component :

#### 1 : Accessors

For each component that uses a specific memento: each variable that is going to be saved must have an accessor. This accessor will be used by the memento associated to the component.

#### 2 : Creation of the mementos

When you have all the necessary accessors you can create the specific memento by extending "MolComponentMemento" or by copying an existing memento and redefine it.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/183371842-bea10c03-a669-4dc7-858b-8239f00ccda8.png" width="50%">

#### 4 : Recording method

Each component that uses a specific memento must override the *saveForTimeTravel* method, which is a method of the ***TimeTravelEvent*** event. This method is similar for all components. This is the creation of the memento and its save.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/183374518-8621dac1-d9d3-4309-87ba-9d6ff9b801a9.png" width="100%">

#### 5 : Restoration method

Each component that uses a specific memento must override the *restoreFrom: aMemento* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This involves restoring the state of a component for a step thanks to its memento for this step.

###### Example:
<img src="https://user-images.githubusercontent.com/64481702/183376017-1b46d8d6-905a-443a-95b5-008bbe9dfd36.png" width="100%">
