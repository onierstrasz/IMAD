"
I contain a bunch of bloc examples that show how to visualize graphs

"
Class {
	#name : #GtModelingExamples,
	#superclass : #GtExampleProvider,
	#category : #'IMAD-FSA'
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
GtModelingExamples >> graphWithDirectedEdges [
	<gtExample>
	| mondrian |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :each | self borderCircleWithLabel: each asString ];
		with: (1 to: 10).
	mondrian edges
		shape: [ :edge | self directedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectTo: [ :x | x // 2 ].
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
