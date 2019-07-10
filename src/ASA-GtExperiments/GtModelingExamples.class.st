"
I contain a bunch of bloc examples that show how to visualize graphs
"
Class {
	#name : #GtModelingExamples,
	#superclass : #GtExampleProvider,
	#category : #'ASA-GtExperiments'
}

{ #category : #examples }
GtModelingExamples >> circleWithText [
	<gtExample>
	"example from ML"
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
GtModelingExamples >> fsaGraph [
	<gtExample>
	| eg view |
	eg := FSA eg1.
	view := GtMondrian new.
	view nodes
		shape: [ :x | 
			BlElement new
				border: (BlBorder paint: Color black);
				geometry: BlCircle new;
				size: 40 @ 40 ];
		with: eg nodes.
	view edges connectToAll: [ :x | eg following: x ].
	view layout circle.
	^ view
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
