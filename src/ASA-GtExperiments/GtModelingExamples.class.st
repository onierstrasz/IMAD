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
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		when: BlClickEvent do: [ self inform: 'Click' ];
		addChild:
			(BlTextElement new
				text: '10' asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #examples }
GtModelingExamples >> fsa4NodeGraph [
	<gtExample>
	^ FSA eg4nodes view
]

{ #category : #broken }
GtModelingExamples >> graphWithCurvedEdges [
	| aView aTwoArgBlock anOneArgBlock view |
	"Original code from (ConfigurationOf class)>>#gtMapFor:selectRelationsThat:nameDisplayedAs:
	To be adapted"
	^ aView mondrian
		title: 'Map';
		priority: 10;
		painting: [ :mondrian |
			| projects |
			projects := Set new.
			self project version 
				withDeep: [ :each | each projects collect: #version ]
				relationDo: [ :a :b | (aTwoArgBlock value: a value: b)
					ifTrue: [ projects add: a; add: b ] ].
			mondrian nodes 
				shape: [ :each | 
					| text element |
					text := [
						| displayString |
						displayString := (((each gtDisplayString 
							copyReplaceAll: 'BaselineOf' with: '')
							copyReplaceAll: 'ConfigurationOf' with: '')
							copyReplaceAll: 'GToolkit' with: 'GT ').
						(anOneArgBlock value: displayString) asRopedText glamorousRegularFont ]
						on: Error do: [ :e | e asString asRopedText foreground: BrGlamorousColors linkWithErrorColor ].
					element := BlTextElement new.
					element 	
						text: text; 
						zIndex: 1; 
						when: BlClickEvent do: [ :e | e consumed: true. element fireEvent: (GtPhlowObjectToSpawn new object: each spec project configuration class; sourceElement: element) ] ];
				with: projects.
			mondrian edges
				shape: [ :each |
					BlParabollaArcElement new 
						zIndex: 0;
						curvatureFraction: 0.2;
						border: (BlBorder paint: (Color gray alpha: 0.2) width: 2);
						toHead: (BlArrowheadSimpleArrow new
							border: (BlBorder builder paint: (Color gray alpha: 0.2); width: 2; build))  ];
				fromRightCenter;
				toLeftCenter;
				connectFrom: #yourself 
				toAll: [:each | |dependedProjects |
					dependedProjects := each projects collect: #version.
					projects select: [ :project | dependedProjects anySatisfy: [ :dependedProject | dependedProject = project ] ] ].
			mondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new levelDistance: 50; nodeDistance: 10)]
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
