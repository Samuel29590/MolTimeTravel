# This is the 10 steps to implement TimeTravel in MolAnts


## 1 : Connect the component TimeTravel to all the other components

Every component of the simulation needs to be connected to the TimeTravel component and to do this every component need to be added as consumer of the ***MATimeTravelEvent*** and user of the ***MATimeTravelService***.

## 2 : Accessors

Each variable that is going to be saved must have an accessor. This accessor will be used by the memento associated to the component.

## 3 : Creation of the mementos

For each component that will be saved, you must create the memento that will be associated with it. This memento will describe the variables that will be saved and how they are saved.

## 4 : Recording method

Each component must describe the *saveForTimeTravel: aStep* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This is the creation of the memento and its save.

## 5 : Restoration method

Each component must describe the *restoreFrom: aMemento* method, which is a method of the ***MATimeTravelEvent*** event. This method is similar for all components. This involves restoring the state of a component for a step thanks to its memento for this step.

## 6 : Creation of components

In the methods *componentInitialize* of each component, it is necessary to add the sends to the component *TimeTravel* of the creation of the component.

## 7 : Deletion of components

In the methods *componentRemove* of each component, it is necessary to add the sends to the component *TimeTravel* of the deletion of the component.

## 8 : Know where to save the simulation at a step

Know where to put the method *saveTheSimulationAt: aStep* which allows to tell all the components to save themselves for this step.

## 9 : Know where to pause and play 

Knowing where the simulation breakpoints must be placed so that when the time travel begins, the simulation is paused. And when we stop the time travel the simulation play.

## 10 : Add the Time Travel panel

Added time travel buttons to the UI and made them work.
