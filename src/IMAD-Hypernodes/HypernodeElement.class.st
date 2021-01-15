"
I provide a dedicated view for a ${class:Hypernode}$ instance as a node within a graph.
"
Class {
	#name : #HypernodeElement,
	#superclass : #AbstractHypernodeElement,
	#instVars : [
		'isEditable',
		'nodeContext'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeElement class >> for: aNode [
	self deprecated: 'Use forContext:'.
	^ self new
		node: aNode;
		yourself
]

{ #category : #accessing }
HypernodeElement class >> forContext: aNodeContext [
	^ self new
		context: aNodeContext;
		yourself
]

{ #category : #accessing }
HypernodeElement >> context [
	^ nodeContext
]

{ #category : #accessing }
HypernodeElement >> context: aNodeContext [
	self assert: aNodeContext isNotNil.
	nodeContext := aNodeContext.
	self handleEvents.
	self graph model: aNodeContext node.
	self subscribe
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
HypernodeElement >> defaultPadding [
	^ 5
]

{ #category : #accessing }
HypernodeElement >> handleEvents [
	self assert: self context isNotNil.
	self
		viewModel: (BrInteractiveModel with: BrHoverModel new);
		look:
			(BrStyleCommonLook new
				default: [ :aStyle | aStyle border: (BlBorder paint: Color black width: 1) ];
				hovered: [ :aStyle | aStyle border: (BlBorder paint: Color red width: 1) ])
				+
					((BrGlamorousWithContextMenuLook content: [ self contextMenu ])
						useSecondaryMouseButton;
						modifiersMatcher: #isCmd;
						yourself).
	"(BrInteractiveCommonLook new
				default: [ :elt | elt border: (BlBorder paint: Color black width: 1) ];
				hovered: [ :elt | elt border: (BlBorder paint: Color red width: 1) ]) +"	"Open context menu on CMD-right-clicked node:"
	"+
					((BrGlamorousWithContextMenuLook content: [ self nodeEditor ]) 
						useSecondaryMouseButton;
						modifiersMatcher: #isEmpty; 
							yourself)"	"right-click"
	"+ (BrGlamorousWithTooltipLook2 content: [ self cardEditor ])"

	"Drag node to new position:"
	self addEventHandler: (HypernodePullHandler for: self).

	"CTRL-drag to create an edge:"
	self addEventHandler: HyperlinkDragHandler new.

	"Spawn new inspect pane on clicked Hypernode:"
	self
		addEventHandler:
			(BlEventHandler
				on: BlDoubleClickEvent
				do: [ :evt | 
					evt consumed: true.	"So the container does not also react."
					self phlow spawnObject: self node ])
]

{ #category : #accessing }
HypernodeElement >> initialize [
	super initialize.
	isEditable := false.
	"NB: the node context will be set by context: when created via HypernodeElement class>>#forContext:"
	self
		layout: BlFrameLayout new;
		geometry: (BlRectangle cornerRadius: 4);
		background: Color white;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: self defaultPadding).
	self updateNode.
	self graph beNode.
	"self handleEvents."
	^ self
]

{ #category : #accessing }
HypernodeElement >> node [
	^ self context node
]

{ #category : #accessing }
HypernodeElement >> node: aNode [
	self deprecated: 'Use context: instead'.
	nodeContext := aNode.
	self graph model: aNode
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
HypernodeElement >> subscribe [
	<todo: 'subscribe to my node''s announcements'>
	"self node announcer when: XYZ do: [] for: self"
]

{ #category : #accessing }
HypernodeElement >> updateNode [
<todo: 'To be wired into announcements!'>
	"card name = card defaultName
		ifTrue: [ self beEditable ]
		ifFalse: [ self beText ].
	self graph model: card"
]
