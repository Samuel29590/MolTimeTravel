# MolRandomPrinterTimeTravel

## Documentation

Start and stop the example like this :

![image](https://user-images.githubusercontent.com/64481702/181501130-994feee3-b610-4c0d-abcc-2fb3a4f7f4d7.png)

The example is simple the component **MolRandomSender** produce one event each time we click on the button *Print random integer smaller than 100*. And the **MolRandomReceiver** consume that event and print a random integer between 1 and 99.

**Illustration :**

![image](https://user-images.githubusercontent.com/64481702/181502121-2b0a2909-4279-47e3-b679-00e4b471d953.png)

**Code of the event :**

![image](https://user-images.githubusercontent.com/64481702/181505179-cf567cb0-a33d-48c1-ad99-888bc6c73a7c.png)


The Time travel start with 4 step ( step 0 : init ( so nothing in it ), step 1 : creation of the sender, step 3 : creation of the receiver, step 4 : the current step).

And each time we click on the button the time travel save the event on a new empty step. So we can replay the execution event by event.

(Each component is a Bloc object *BlElement or BlTextElement* their implementation and initialization as Bloc object isn't important, we focus on time travel and event recording)

## **⚠️**  The problem :

When we time travel, because it's a random integer that the receiver print, the execution is always different even if it's the same conditions. 
