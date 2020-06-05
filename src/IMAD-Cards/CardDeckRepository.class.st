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
				name: 'Element';
				description:
					'An element is a widget.

!FAQ
How to get an element in a window by itself?
Put it inside a ${class:name=BlSpace}$:
[[[
BlSpace new
 title: ''Space'';
 extent: 1200 @ 600;
 addChild: (BlElement new background: Color red);
 withHalos;
 show
]]]


';
				addTag: 'm2';
				yourself);
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
				description:
					'TG: A "look" is like a CSS class, but it can add event handlers as well.
A look is an operator with which to modify an element at runtime.
We initially created it to support theming, and then we discovered that by enabling it to modify anything in the rendering tree, we get a rather powerful tool. The look can change everything about the sub elements, layouts, interactions.

See the comment of ${class:name=BrLook}$.

Looks can also be composed, for example,
[[[
BrGlamorousButtonWithIconLook new
]]]
shows that it is made of 4 other looks.

So, this:
[[[
BrButton new 
	look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook;
	icon: BrGlamorousIcons hamburger asElement;
	label: ''Menu''
]]]
simply means that we are not taking ${class:name=BrGlamorousButtonExteriorLook}$ into account in this case, and we will get no border.


';
				addTag: 'm2';
				yourself);
		addCard:
			(Card new
				name: 'Mondrian';
				description:
					'See ${class:name=GtMondrianVsBlocExplanation}$  and ${class:name=GtMondrianBasicExamples}$.


Mondrian offers a graph-builder API on top of Bloc and Brick.
It leverages Bloc elements that embed graph structure in the userdata dictionary.
The BlElement of a mondrian is its root.
Any BlElement may have a graph context stored in its userData.
This can be queried to check if it is a node or an edge, for example.
Otherwise Bloc elements do not know anything about graphs.
To get to the actual nodes and edges of a mondrian m, go to: m root children
You can query each child c: c graph isNode
You can also simply ask for: root graph nodeChildren';
				addTag: 'tool';
				addTag: 'm2';
				yourself);
		addCard:
			(Card new
				name: 'Stencil';
				description:
					'A Stencil is a factory of elements.
It offers a create method to create the element, which is called asElement.
Anything the implements asElement can be used in place of a stencil.

A block that returns an element can be turned into a stencil by sending it asStencil.

A view is also a factory that creates an element, but it does it through asElementDo: .

See: BrStencil comment

TG: A Stencil is a factory of elements. It is not a BlElement.
Anything that supports asElement can be used as a stencil.

!Questions
What is the intended meaning of the “create” method?
It''s the method used by a stencil to create an element.
See the comment of ${class:name=BrStencil}$  and ${method:name=BrStencil>>#asElement}$.

';
				addTag: 'm2';
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


TG: A PhlowView is similar to a stencil (even if slightly differently implemented).
A view is also a factory that creates an element, but it does it through asElementDo: .
PhlowView is right now only used in the inspector, but it is not limited to it.

!Questions
Are Views dedicated to Inspectors? ("Inspector views"?)

What is asElementDo: for? ("it evaluates aBlock if the view should have content")
Is a view an Element? If not, what''s the difference?';
				addTag: 'm2';
				yourself);
		addRelation: 'factoryFor'
			fromCardNamed: 'Stencil'
			toCardNamed: 'Element';
		yourself
]

{ #category : #accessing }
CardDeckRepository >> imadTodos [
	<gtExample>
	^ CardDeck new
		name: 'IMAD Design';
		description:
			'This deck on the one hand documents the IMAD prototype design, to-dos and pending topics, and on the other hand serves as a test  case for IMAD itself.

!How to load IMAD:

PharoLightTheme beCurrent.
Metacello new baseline: ''IMAD''; repository: ''github://onierstrasz/IMAD/src''; load.
Smalltalk saveAs: ''IMAD.1''.

!Some decks to load:

[[[
CardDeckRepository new garageDoorRemote inspect
]]]

[[[
CardDeckExamples new facultyDoodleDomain inspect
]]]

[[[
CardDeckRepository new imadTodos inspect
]]]

[[[
CardDeckRepository new gtOverview inspect
]]]

';
		set: #storageClassName to: 'CardDeckRepository';
		set: #storageMethodName to: 'imadTodos';
		addCard:
			(Card new
				name: 'Short term to-dos';
				description:
					'
!To do

- create new Graph view
    - create pure Brick version
    - tags for subviews
        - add tag view filter
    - better display of text
    - button to select layouts
        - force-based layout
    - interactively create/delete cards and links
- expand Garage door example
    - states are also cards?

- BlNearestPositionBoundsAnchor stinks
    - need a better version that grows through centers?

- add Card features
    - need more property types? (lists, dictionaries?)

- instead of typing tags, select from available tags?

- look at GtHome


';
				addTag: 'todo';
				yourself);
		addCard:
			(Card new
				name: 'Tag';
				description:
					'!Overview
Tags (for cards) can be seen as subsets of cards, hyperedges between them, or as "types".
Possible usages: 
- distinguish m1 and m2 entities
- identify all entities of a scenario or a use case (name of use case)
- identify types of nodes (state, event, entity, instance)

!Querying
Tags can be used to identify subsets of nodes.
For a given graph view, could select a number of tags to indicate the intersection of tags.
Could also use disjuntive normal form for a more complex query (unions of intersections).
It would be useful to be able to save a query as a card (a "view").
Could then also associate a "visualization style" with that view.
(Specification how to map nodes and edges to visualizations, possibly by tags.)
!Standard tags
There should be a set of standard tags available (m1, m2, actor, state, etc.).
A given card deck could augment it with some default tags relevant for that deck.
Then ad hoc tags are those that appear when assigned to a given card.
A view would have access to the union of all available tags.
!To do
- tag interface for cards (already done)
- tag queries for Graph view';
				addTag: 'm2';
				yourself);
		yourself
]
