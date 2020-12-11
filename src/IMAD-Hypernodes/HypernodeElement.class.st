"
I provide a dedicated view for a ${class:Hypernode}$ instance as a node within a graph.
"
Class {
	#name : #HypernodeElement,
	#superclass : #BlElement,
	#instVars : [
		'node',
		'isEditable'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeElement class >> for: aNode [
	^ self new
		node: aNode;
		yourself
]

{ #category : #accessing }
HypernodeElement >> contextMenu [
	<todo: 'context menu for nodes'>
	| menu |
	menu := BrGlamorousSimpleContextMenuContent new
		items:
			{
			
			"('Rename card'
				-> [ isEditable
						ifFalse: [ self beEditable ] ]).
			('Inspect card' -> [ card inspect ]).
			('Delete card'
				-> [ menu anchor: BlElement new.
					card delete ])"
					
					};
		yourself.
	^ menu
]

{ #category : #accessing }
HypernodeElement >> handleEvents [
	self
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color black width: 1) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color blue width: 1) ])
				+
					((BrGlamorousWithContextMenuLook content: [ self contextMenu ])
						useSecondaryMouseButton;
						modifiersMatcher: #isCmd;
						yourself).	"Open context menu on CMD-right-clicked node:"
	"+
					((BrGlamorousWithContextMenuLook content: [ self nodeEditor ]) 
						useSecondaryMouseButton;
						modifiersMatcher: #isEmpty; 
							yourself)"	"right-click"
	"+ (BrGlamorousWithTooltipLook2 content: [ self cardEditor ])"

	"Drag node to new position:"
	self addEventHandler: HypernodePullHandler new.

	"CTRL-drag to create an edge:"
	self addEventHandler: HyperlinkDragHandler new.

	"Spawn new inspect pane on clicked Hypernode:"
	self
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					evt consumed: true.	"So the container does not also react."
					self phlow spawnObject: node ])
]

{ #category : #accessing }
HypernodeElement >> initialize [
	super initialize.
	node := Hypernode new.
	isEditable := false.
	self
		layout: BlFrameLayout new;
		geometry: (BlRectangle cornerRadius: 4);
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 5).
	self updateNode .
	self graph beNode.
	self handleEvents.
	^ self
]

{ #category : #accessing }
HypernodeElement >> node: aNode [
	node := aNode
]

{ #category : #accessing }
HypernodeElement >> nodeEditor [
"for right-click"
	"| element |
	element := (self card gtDescriptionFor: GtPhlowEmptyView new)
		asElementDo: #yourself.
	(element childNamed: #doc)
		fitContent;
		hExact: 300.
	element
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ].
	^ element asScrollableElement"
]

{ #category : #accessing }
HypernodeElement >> updateNode [
<todo: '...'>
	"card name = card defaultName
		ifTrue: [ self beEditable ]
		ifFalse: [ self beText ].
	self graph model: card"
]
