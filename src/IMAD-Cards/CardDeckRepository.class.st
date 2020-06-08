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
		name: 'IMAD Design Todos';
		description:
			'This deck on the one hand documents the IMAD prototype design, to-dos and pending topics, and on the other hand serves as a test  case for IMAD itself.

!How to load IMAD:

PharoLightTheme beCurrent.
Metacello new baseline: ''IMAD''; repository: ''github://onierstrasz/IMAD/src''; load.
Smalltalk saveAs: ''IMAD.1''.

!Github repo

[[[]
WebBrowser openOn: ''https://github.com/onierstrasz/IMAD''
]]]

!Some decks to load:
This deck:
[[[
CardDeckRepository new imadTodos inspect
]]]

A state diagram (in progress):
[[[
CardDeckRepository new garageDoorRemote inspect
]]]

A faculty modeling example (in progress):
[[[
CardDeckExamples new facultyDoodleDomain inspect
]]]

Overview of Gt concepts (in progress):
[[[
CardDeckRepository new gtOverview inspect
]]]

';
		set: #storageClassName to: 'CardDeckRepository';
		set: #storageMethodName to: 'imadTodos';
		addCard:
			(Card new
				name: 'Card';
				description:
					'A Card is a modeling entity. It can be a domain concept, i.e., a metamodel (m2) entity, or it could be an instance of a concept (m1). It could also be another kind of modeling entity, such as an actor (same as an instance), a state, an event, a use case, a scenario etc etc.

A card has a name and a description. It also has a set of properties (key-value pairs) and a set of named tags. The properties can be used for details of the entity being modeled. Tags are rather used to classify, group and type cards. 

Cards can be displayed in different ways, cependinbg on their tags, their properties and the context. For example, a state might be shown as a circle in an FSA, or as a blob in a statechart.

A card is implemented by the class ${class:name=Card}$. 
';
				addTag: 'm2';
				yourself);
		addCard:
			(Card new
				name: 'Card Deck';
				description:
					'A Card Deck is a collection of cards used to model various aspects of some domain.

It is implemented by the class ${class:name=CardDeck}$.
';
				addTag: 'm2';
				yourself);
		addCard:
			(Card new
				name: 'Card Deck View';
				description:
					'A view of a card deck offers a graph-based view of a subset of the cards in a deck.
It could select, for example, just the meta-model (m2 tags), or a partciular use case or scenario, or a state-machine view of a given actor.

A view consists of two key parts:

1. a query that selects the subset of cards of a deck
2. a specification of the visualization style for the view

The query could be a set of tags, or possible a disjunctive normal form (unions of intersections). It could also include some queries or filters over other properties of the cards.

The style should determine how nodes (cards) and edges (relations) are rendered, how they are laid out, and what interactions are supported. Mostly this should be restricted to a set of prepackaged styles, but perhaps there could be some ad hoc configuration, eg to select display types of nodes and edges (circles, rectangles, colours etc).

It should be possible to save a view as a card with the tag "view".
';
				addTag: 'm2';
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
		addCard:
			(Card new
				name: 'To do';
				description:
					'
!!Small things to do
- Navigate from card to deck view

!!Graph view
- Factor out the Graph view into a separate class

!Interactions
- Create a relation
- Double-click on relation to open details
- Tags to filter
- Change/select layout

!Styles (views)
- Choice of views for nodes and edges
- Edges: straight, curved, labeled, arrows, colors, thickness
- Nodes: Boxes, rounded boxes, circles, ellipses, bars, icons, closed
- NB: Explore looks as a way to dynamically change the appearance of elements.

!Tags
- select tags to view
- advanced: compose tag filter (disjunctive NF?)
- save view as a card?

!Layouts
- Force-based layout
- Circle layout
- Tree layout (root?)
- Manual layout (how to remember?)

!Examples    
- expand Garage door example (states as cards?)

!Gt improvements
- ${class:name=BlNearestPositionBoundsAnchor}$ stinks -- need a better version that grows through centers?

!To study
- look at ${class:name=GtHome}$
- find examples of using Looks to dynamically  change views. ${class:name=BrLookChangeExamples}$.

!!Nice to have
- "dirty" flag for modified deck; clear when saved (change colour of save button when dirty)

';
				addTag: 'todo';
				yourself);
		addRelation: 'belongsTo'
			fromCardNamed: 'Card'
			toCardNamed: 'Card Deck';
		yourself
]
