# EIStateMachine

An Objective-C implementation of the Finite State Machine pattern.

## History
This library is a bit of a hodgepodge. My father, Ross Pink, has been using state machines for embedded systems programming in FORTH since he was taught the technique at Uni in the 70's. He swears by this one particular style of state machine and has used it very effectively to produce reliable electronic controllers throughout his career.

Ross taught me this particular style of state machine but I have had trouble trying to implement it in an object oriented fashion. I mentioned my dilemma to a friend, Matt Connolly, and after thinking about it for a while he proposed the current solution.

The key features of the method are
- A states entire code base is grouped in one section of code
- A state machines entire code base is contained in a single file (.h/.m file pair)

This is a bit different to most modern state machine techniques which group the state definitions into one table and the state transitions into another table. I prefer EIStateMachine's approach as the entirety of a states computation (All of the events it can receive and the reasons to transition to another state) are all presented in the one section of code. I find it easier to reason about the code in this format.

The fact that the library uses Objective-C's forwarding mechanism is simply a means to provide the qualities listed above.

