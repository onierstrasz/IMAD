"
I am responsible for defining the appearance of graphs.
I select the the appearance of nodes and edges, and the layout.
I can also specify a mapping from tags to different appearances.

I am further responsible for mapping UI events to model events (to be defined).

A style is defined as a configuration, a property list (nested dictionary).
Some configurations are predefined, and others can be provided by a GUI, or retrieved from properties of a card deck or a given card.

(Last updated 2020-08-05)
"
Class {
	#name : #CardGraphStyle,
	#superclass : #Object,
	#instVars : [
		'configuration'
	],
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardGraphStyle >> directedCurvedEdge [
	<todo: 'Use this to build graphs?'>
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #accessing }
CardGraphStyle >> initialize [
	super initialize.
	configuration := Dictionary new.
	self mindmapStyle
]

{ #category : #accessing }
CardGraphStyle >> layout [
	<todo: 'determine the style from the configuration'>
	^ BlOnceLayout new layout: GtGradHorizontalTreeLayout new
	

	"(self cards size > 1
				ifTrue: [ BlOnceLayout new layout: GtGradCircleLayout new ]
				ifFalse: [ BlOnceLayout new layout: GtGradHorizontalTreeLayout new ])"
]

{ #category : #accessing }
CardGraphStyle >> mindmapStyle [
	<todo: 'initialize mindmap defaults'>
]
