Class {
	#name : #CardDeckRepository,
	#superclass : #Object,
	#category : #'IMAD-Cards-CardDecks'
}

{ #category : #accessing }
CardDeckRepository >> garageDoorRemote [
	<gtExample>
	^ CardDeck new
		name: 'Garage Door Remote';
		description:
			'(State machine example from EI Computational Thinking lecture.)

Entities are:
- A Garage Door
- A remote control
- A car
- A Sensor

A garage door can be in one of the following states:

Open
Closed
Opening
Closing
Stopped (while opening)
Stopped (while closing).

The door changes state when it receives a signal from the remote, or from a sensor.

In this example we can describe the m2 entities, and a concrete m1 scenario.
';
		set: #storageClassName to: 'CardDeckRepository';
		set: #storageMethodName to: 'garageDoorRemote';
		addCard:
			(Card new
				name: 'Garage Door';
				description:
					'A garage door can be in one of the following states:

Open
Closed
Opening
Closing
Stopped (while opening)
Stopped (while closing).

The door changes state when it receives a signal from the remote, or from a sensor.
';
				yourself);
		addCard:
			(Card new
				name: 'Homer''s Garage Door';
				description: 'To do';
				yourself);
		addCard:
			(Card new
				name: 'Homer''s Remote';
				description: 'To do';
				yourself);
		addCard:
			(Card new
				name: 'Remote Control';
				description:
					'The remote has a single button. Pressing it causes the door to change state, i.e., from closed to opening, etc.';
				yourself);
		addRelation: 'instanceOf'
			fromCardNamed: 'Homer''s Garage Door'
			toCardNamed: 'Garage Door';
		addRelation: 'instanceOf'
			fromCardNamed: 'Homer''s Remote'
			toCardNamed: 'Remote Control';
		addRelation: 'controls'
			fromCardNamed: 'Remote Control'
			toCardNamed: 'Garage Door';
		yourself
]

{ #category : #accessing }
CardDeckRepository >> gtOverview [
	<gtExample>
	^ CardDeck new
		name: 'Gt Overview';
		description: 'This deck documents what I have learned about Gt.';
		set: #storageClassName to: 'CardDeckRepository';
		set: #storageMethodName to: 'gtOverview';
		addCard:
			(Card new
				name: 'Layout';
				description:
					'To make an individual element draggable, need to add an event handler.
To make them draggable in a tree layout, need to decorate the treelayout with BlOnceLayout, but this replaces the container (?) with a BasicLayout, which clips the area -- this will be fixed.

TG: An element can nest children, and it arranges its children through a Layout. Children can optionally define constraints that the layout will take into account.

!Questions
What is the difference between a Layout and a Look?
';
				yourself);
		addCard:
			(Card new
				name: 'Look';
				description: 'To do';
				yourself);
		addCard:
			(Card new
				name: 'Mondrian';
				description:
					'See ${class:name=GtMondrianVsBlocExplanation}$.


Mondrian offers a graph-builder API on top of Bloc and Brick.
It leverages Bloc elements that embed graph structure in the userdata dictionary.
The BlElement of a mondrian is its root.
Any BlElement may have a graph context stored in its userData.
This can be queried to check if it is a node or an edge, for example.
Otherwise Bloc elements do not know anything about graphs.
To get to the actual nodes and edges of a mondrian m, go to: m root children
You can query each child c: c graph isNode
You can also simply ask for: root graph nodeChildren';
				yourself);
		addCard:
			(Card new
				name: 'Stencil';
				description:
					'A Stencil is a factory of elements.
It offers a create method to create the element, which is called by asElement.
Anything the implements asElement can be used in place of a stencil.

A block that returns an element can be turned into a stencil by sending it asStencil.

See: BrStencil comment

TG: A Stencil is a factory of elements. It is not a BlElement.
Anything that supports asElement can be used as a stencil.

!Questions

';
				yourself);
		addCard:
			(Card new
				name: 'View';
				description:
					'A view is a way to present a given object (model). An object may support multiple views.
Each view is defined by a method with the <gtView> pragma, takes a argument "aView", constructs the view by sending messages to this entity, and finally returns the view.

GtPhlowView comment
“A view is a stencil, a specification of how the concrete view widget will be created. Beside the logic of creating the widget, the view also specifies the ==title==, and the ==phlowActions== (see ${class:GtPhlowAction}$).”

GtPhlowProtoView defines the common API of views

Gt supports different kinds of views
Lists, columned list, mondrian etc

The explicit view lets you visualize an object in any way you want. Using the stencil:  block you can give that visualization any shape or form. 

An empty view is not visible. Conditionally create this if a view might not be needed.


TG: A PhlowView is similar to a stencil (even if slightly differently implemented)
PhlowView is right now only used in the inspector, but it is not limited to it.

!Questions
Are Views dedicated to Inspectors? ("Inspector views"?)

What is asElementDo: for? ("it evaluates aBlock if the view should have content")
Is a view an Element? If not, what''s the difference?';
				yourself);
		yourself
]
