"
I contain a bunch of bloc examples that show how to visualize graphs
"
Class {
	#name : #GtModelingExamples,
	#superclass : #GtExampleProvider,
	#category : #'ASA-GtExperiments'
}

{ #category : #examples }
GtModelingExamples >> borderCircleWithLabel [
	<gtExample>
	^ self borderCircleWithLabel: '10'
]

{ #category : #utilities }
GtModelingExamples >> borderCircleWithLabel: aString [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		when: BlClickEvent do: [ self inform: 'Click' ];
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #examples }
GtModelingExamples >> colourChangingCircle [
	"Circle changes colour when you click on it"

	<gtExample>
	| node |
	node := BlElement new.
	node
		background: (Color green darker alpha: 1);
		geometry: BlCircle new;
		when: BlClickEvent do: [ node background: Color red ].
	^ node
]

{ #category : #utilities }
GtModelingExamples >> directedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #examples }
GtModelingExamples >> fsa10NodeGraph [
	<gtExample>
	^ FSA eg10nodes view
]

{ #category : #examples }
GtModelingExamples >> fsa4NodeGraph [
	<gtExample>
	^ FSA eg4nodes view
]

{ #category : #examples }
GtModelingExamples >> graphWithDirectedEdges [
	<gtExample>
	| nodes mondrian |
	nodes := 1 to: 10.
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :each | self borderCircleWithLabel: each asString ];
		with: (1 to: 10).
	mondrian edges
		shape: [ :edge | self directedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectTo: [ :x | x // 2 ].
	"mondrian layout
		custom:
			(GtGradHorizontalDominanceCenteredTreeLayout new
				levelDistance: 50;
				nodeDistance: 10)."
	mondrian layout tree.
	^ mondrian
]

{ #category : #examples }
GtModelingExamples >> graphWithTenLinkedNodes [
	"Simple example directly linking nodes"

	<gtExample>
	| mondrian |
	mondrian := GtMondrian new.
	mondrian nodes with: (1 to: 10).
	mondrian edges connectTo: [ :x | x // 2 ].
	mondrian layout tree.
	^ mondrian
]

{ #category : #examples }
GtModelingExamples >> greenCircleWithFittedText [
	"example from ML"

	<gtExample>
	^ BlElement new
		layout: BlFrameLayout new;
		background: (Color green darker alpha: 1);
		geometry: BlCircle new;
		when: BlClickEvent do: [ self inform: 'Click' ];
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		addChild:
			(BlTextElement new
				text: 'hello world' asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter.
					c horizontal fitContent.
					c vertical fitContent ];
				yourself);
		yourself
]

{ #category : #examples }
GtModelingExamples >> gtProjectMap [
	"Example of graph with arrows"

	<gtExample>
	^ BaselineOfGToolkit gtGtMapFor: GtPhlowProtoView new

	"Source: (ConfigurationOf class)>>#gtMapFor:selectRelationsThat:nameDisplayedAs:"
]

{ #category : #playgrounds }
GtModelingExamples >> pgCircleGraph [

	"Just a place to store working script"

	GTPlayground openContents: '| eg view |
eg := FSA eg1.
view := GtMondrian new.

view nodes
	shape: [: x |
		BlElement new
			border: (BlBorder paint: Color black);
			geometry: BlCircle new;
			size: 40 @ 40
		];
	with: eg nodes
	.

view edges connectToAll: [ :x | eg following: x ].

view layout circle.
^ view

' label: 'Workspace'.
]
