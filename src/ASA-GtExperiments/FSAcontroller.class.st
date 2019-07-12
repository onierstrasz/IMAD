"
I represent the controller for a view of an FSA model.

I color the current state of the FSA as a green node in the view.
I gather mouse click events from the view, and interpret them as transition requests.
If the model accepts the transition as valid, I update the view.
If the FSA is dead, I color the current state as red instead of green.
"
Class {
	#name : #FSAcontroller,
	#superclass : #Object,
	#instVars : [
		'fsa',
		'view',
		'viewNodes',
		'current'
	],
	#category : #'ASA-GtExperiments'
}

{ #category : #'instance creation' }
FSAcontroller class >> forModel: anFSA andView: aView [
	^ self new
		initializeModel: anFSA andView: aView;
		yourself
]

{ #category : #'view control' }
FSAcontroller >> clearFSAstateColor [
	self currentNode background: Color white
]

{ #category : #'view control' }
FSAcontroller >> clickOn: aNodeElement [
	| node |
	node := aNodeElement graph model.
	(fsa isTarget: node)
		ifTrue: [ fsa go: node ]
		ifFalse: [ self inform: node asString , ' is not a valid target' ]
]

{ #category : #'model interaction' }
FSAcontroller >> currentNode [
	^ viewNodes detect: [ : each | each graph model = current ]
]

{ #category : #'view control' }
FSAcontroller >> deadColor [
	^ Color red
]

{ #category : #initialization }
FSAcontroller >> initializeModel: anFSA andView: aView [
	fsa := anFSA.
	current := fsa current.
	view := aView.
	viewNodes := view children select: [ :each | each graph isNode ].
	viewNodes
		do: [ :aNode | aNode when: BlClickEvent do: [ self clickOn: aNode ] ].
	self setFSAstateColor.
]

{ #category : #'view control' }
FSAcontroller >> liveColor [
	^ (Color green darker alpha: 1)
]

{ #category : #'view control' }
FSAcontroller >> setFSAstateColor [
	self currentNode
		background:
			(fsa isLive
				ifTrue: [ self liveColor ]
				ifFalse: [ self deadColor ])
]

{ #category : #'model interaction' }
FSAcontroller >> update: anFSA [
	self clearFSAstateColor.
	current := fsa current.
	self setFSAstateColor
]
