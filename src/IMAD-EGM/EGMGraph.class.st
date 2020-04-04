"
I represent the basic graph model which consists of nodes and edges. The Interactive Graph Editor is based on me. Further I represent the logic of a directed graph, a Finite State Automata (FSA) and a Petri Net.


Interactive Graph Editor

To create your own graph, inspect:
	Graph new
Switch to the _GT tab, where you can create a graph and add semantics.

Use right click to:
	- add different nodes (basic node, transition, place)
	- create a graph example, i.e. export the created graph as an example method that is added to the graph model
	- switch to execution mode, where you can fire transitions (Petri Net) and select successor states (FSA) with left click

Use left click on nodes to:
	- delete the node
	- select the node for adding a new edge (from/to)
	- set node as initial state (FSA)
	- set number of tokens (place)

Use left click on edges to:
	- delete the edge
	- set the weight


To see a graphical representation of an FSA, inspect the following example and switch to _GT tab.
Switch to execution mode (right click), then you can select successor states (left click on successor node).
	Graph new fsaExample	
	
		
To see a graphical representation of a Petri Net inspect the following example and switch to _GT tab.
Switch to the execution mode (right click), then you can fire enabled transitions (left click).
	Graph new diningPhilosophersExample


Bug report (view):

To reproduce the bug, inspect the following example and switch to _GT tab.
If you switch back to the Raw tab and then back to the _GT, a greyed out window appears.
	Graph new

"
Class {
	#name : #EGMGraph,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'edges',
		'places',
		'weights',
		'transitions',
		'tokens',
		'currentState',
		'selectedNode',
		'debug',
		'nodeLocations',
		'nodeSizes',
		'edgeCurvatures'
	],
	#category : #'IMAD-EGM'
}

{ #category : #tests }
EGMGraph class >> eg10nodes [
	<gtExample>
	^ self new nodes: (0 to: 10) asOrderedCollection;
		edges:
			((0 to: 10)
				flatCollect: [ :x | 
					{(x -> (x * 3 \\ 10)).
					(x -> (x // 2))} ]) asOrderedCollection;
		currentState: 10
]

{ #category : #tests }
EGMGraph class >> egEmptyEditor [
	<gtExample>
	^ self new
]

{ #category : #adding }
EGMGraph >> addEdgeFrom: nodeA to: nodeB [
	(edges includes: (nodeA->nodeB)) ifTrue: [ ^ 0 ].
	(((transitions includes: nodeA) and: (places includes: nodeB)) or:
		((places includes: nodeA) and: (transitions includes: nodeB))) ifTrue: [
			self weights at: (nodeA->nodeB) put: 1.
			^ self edges add: (nodeA->nodeB) ].
	(((transitions includes: nodeA) or: (places includes: nodeB)) or: ((places includes: nodeA) or: (transitions includes: nodeB))) ifTrue: [ ^ 0].
	self weights at: (nodeA->nodeB) put: 0.
	^ self edges add: (nodeA->nodeB)
]

{ #category : #adding }
EGMGraph >> addNode [
	| newNode |
	nodes isEmpty
		ifTrue: [ newNode := 1 ]
		ifFalse: [ newNode := nodes last + 1 ].
	self nodes add: newNode.
	^ newNode
]

{ #category : #adding }
EGMGraph >> addPlace [
	| newPlace |
	newPlace := self addNode.
	places add: newPlace.
	tokens at: newPlace put: 0.
	^ newPlace
]

{ #category : #adding }
EGMGraph >> addTransition [
	| newTransition |
	newTransition:= self addNode.
	transitions add: newTransition.
	^ newTransition
]

{ #category : #accessing }
EGMGraph >> currentState [
	^ currentState
]

{ #category : #accessing }
EGMGraph >> currentState: anObject [
	currentState := anObject.
	self changed.
]

{ #category : #accessing }
EGMGraph >> debug [
	^ debug
]

{ #category : #accessing }
EGMGraph >> debug: anObject [
	debug := anObject
]

{ #category : #'as yet unclassified' }
EGMGraph >> deleteConnectedEdgesOf: aNode [
	(edges select: [ :edge | edge value = aNode or: edge key = aNode]) do: [ :edge | edges remove: edge].
]

{ #category : #'as yet unclassified' }
EGMGraph >> deleteEdge: anEdge [
	edges remove: anEdge ifAbsent: [ ].
	weights removeKey: anEdge ifAbsent: [ ]
]

{ #category : #utilities }
EGMGraph >> deleteNode: aNode [
	nodes remove: aNode.
	(transitions includes: aNode) ifTrue: [ transitions remove: aNode ].
	(places includes: aNode) ifTrue: [ places remove: aNode ].
	(tokens includesKey: aNode) ifTrue: [ tokens removeKey: aNode ].
	self deleteConnectedEdgesOf: aNode.
]

{ #category : #example }
EGMGraph >> diningPhilosophersExample [
<gtExample>
self nodes: #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20) asOrderedCollection.
self places: #(11 12 13 14 15 16 17 18 19 20) asOrderedCollection.
self transitions: #(1 2 3 4 5 6 7 8 9 10) asOrderedCollection.
self edges: {12->5. 12->1. 13->1. 13->2. 14->3. 14->2. 15->4. 15->3. 11->4. 11->5. 6->12. 6->13. 8->13. 8->14. 9->15. 9->14. 10->15. 10->11. 7->11. 7->12. 1->16. 16->6. 2->20. 20->8. 3->19. 19->9. 4->18. 18->10. 5->17. 17->7} asOrderedCollection.
self currentState: 0.
self weights: {(12->5)->1.(12->1)->1.(13->1)->1.(13->2)->1.(14->3)->1.(14->2)->1.(15->4)->1.(15->3)->1.(11->4)->1.(11->5)->1.(6->12)->1.(6->13)->1.(8->13)->1.(8->14)->1.(9->15)->1.(9->14)->1.(10->15)->1.(10->11)->1.(7->11)->1.(7->12)->1.(1->16)->2.(16->6)->2.(2->20)->2.(20->8)->2.(3->19)->2.(19->9)->2.(4->18)->2.(18->10)->2.(5->17)->2.(17->7)->2} asOrderedDictionary.
self tokens: { 11->1. 12->1. 13->1. 14->1. 15->1. 16->0. 17->0. 18->0. 19->0. 20->0} asOrderedDictionary.
self nodeLocations: { 1->(434.0@523.0). 2->(891.0@533.0). 3->(965.0@198.0). 4->(649.0@10.0). 5->(345.0@190.0). 6->(596.0@342.0). 7->(559.0@245.0). 8->(734.0@341.0). 9->(751.0@244.0). 10->(653.0@200.0). 11->(482.0@85.0). 12->(391.0@334.0). 13->(671.0@509.0). 14->(939.0@338.0). 15->(829.0@86.0). 16->(516.0@425.0). 17->(443.0@198.0). 18->(658.0@90.0). 19->(868.0@198.0). 20->(817.0@421.0)} asOrderedDictionary.
self nodeSizes: { 1->(60.0@15.0). 2->(60.0@15.0). 3->(60.0@15.0). 4->(60.0@15.0). 5->(60.0@15.0). 6->(60.0@15.0). 7->(60.0@15.0). 8->(60.0@15.0). 9->(60.0@15.0). 10->(60.0@15.0). 11->(50.0@50.0). 12->(50.0@50.0). 13->(50.0@50.0). 14->(50.0@50.0). 15->(50.0@50.0). 16->(50.0@50.0). 17->(50.0@50.0). 18->(50.0@50.0). 19->(50.0@50.0). 20->(50.0@50.0)} asOrderedDictionary.
self edgeCurvatures: {(12->5)->0.(12->1)->0.(13->1)->0.(13->2)->0.(14->3)->0.(14->2)->0.(15->4)->0.(15->3)->0.(11->4)->0.(11->5)->0.(6->12)->0.(6->13)->0.(8->13)->0.(8->14)->0.(9->15)->0.(9->14)->0.(10->15)->0.(10->11)->0.(7->11)->0.(7->12)->0.(1->16)->0.(16->6)->0.(2->20)->0.(20->8)->0.(3->19)->0.(19->9)->0.(4->18)->0.(18->10)->0.(5->17)->0.(17->7)->0} asOrderedDictionary.

]

{ #category : #accessing }
EGMGraph >> edgeCurvatures [
	^ edgeCurvatures
]

{ #category : #accessing }
EGMGraph >> edgeCurvatures: anObject [
	edgeCurvatures := anObject
]

{ #category : #accessing }
EGMGraph >> edges [
	^ edges
]

{ #category : #accessing }
EGMGraph >> edges: anObject [
	edges := anObject
]

{ #category : #'public interface' }
EGMGraph >> fireTransition: aTransition [
	(self predecessorOf: aTransition) do: [ :place | tokens at: place put: (tokens at: place) - (weights at: (place->aTransition)) ].
	(self successorOf: aTransition) do: [ :place | tokens at: place put: (tokens at: place) + (weights at: (aTransition->place)) ].


]

{ #category : #example }
EGMGraph >> fsaExample [
<gtExample>
self nodes: #(1 2 3 4 5 6 7 8 9 10) asOrderedCollection.
self places: #() asOrderedCollection.
self transitions: #() asOrderedCollection.
self edges: {1->2. 2->3. 3->2. 3->4. 5->6. 5->7. 6->8. 7->9. 9->10. 8->10. 6->9. 7->8} asOrderedCollection.
self currentState: 1.
self weights: {(1->2)->0.(2->3)->0.(3->2)->0.(3->4)->0.(5->6)->0.(5->7)->0.(6->8)->0.(7->9)->0.(9->10)->0.(8->10)->0.(6->9)->0.(7->8)->0} asOrderedDictionary.
self tokens: {} asOrderedDictionary.
self nodeLocations: { 1->(375.0@138.0). 2->(275.0@217.0). 3->(185.0@130.0). 4->(282.0@59.0). 5->(578.0@141.0). 6->(681.0@49.0). 7->(691.0@229.0). 8->(826.0@47.0). 9->(832.0@229.0). 10->(949.0@131.0)} asOrderedDictionary.
self nodeSizes: { 1->(50.0@50.0). 2->(50.0@50.0). 3->(50.0@50.0). 4->(50.0@50.0). 5->(50.0@50.0). 6->(50.0@50.0). 7->(50.0@50.0). 8->(50.0@50.0). 9->(50.0@50.0). 10->(50.0@50.0)} asOrderedDictionary.
self edgeCurvatures: {(1->2)->0.3.(2->3)->0.3.(3->2)->0.3.(3->4)->0.3.(5->6)->0.(5->7)->0.(6->8)->0.(7->9)->0.(9->10)->0.(8->10)->0.(6->9)->0.(7->8)->0} asOrderedDictionary.

]

{ #category : #ui }
EGMGraph >> gtElement: aView [
	<gtView>

	^ aView explicit
		title: 'View';
		stencil: [ EGMGraphView new viewFor: self ]
]

{ #category : #initialization }
EGMGraph >> initialize [
	nodes:= OrderedCollection new.
	edges:= OrderedCollection new.
	places := OrderedCollection new.
	transitions := OrderedCollection new.
	tokens := OrderedDictionary new.
	weights := OrderedDictionary new.
	nodeLocations := OrderedDictionary new.
	nodeSizes := OrderedDictionary new.
	edgeCurvatures := OrderedDictionary new.
	currentState := 0.
	selectedNode := 0.
	debug := 0.
]

{ #category : #'public interface' }
EGMGraph >> isEnabled: aTransition [
	(transitions includes: aTransition) ifFalse: [ ^false ].
	((self predecessorOf: aTransition) isEmpty or: (self successorOf: aTransition) isEmpty) ifTrue: [ ^false ].
	(((self predecessorOf: aTransition) select: [ :place | (tokens at: place) < (weights at: (place->aTransition))]) isNotEmpty) ifTrue: [^false].
	^true


]

{ #category : #'as yet unclassified' }
EGMGraph >> nodeDeletionBug [
<gtExample>
self nodes: #(1 2 3 4) asOrderedCollection.
self places: #() asOrderedCollection.
self transitions: #() asOrderedCollection.
self edges: {1->3. 3->2. 4->2} asOrderedCollection.
self currentState: 0.
self weights: {(1->3)->0.(3->2)->0.(4->2)->0} asOrderedDictionary.
self tokens: {} asOrderedDictionary.
self nodeLocations: { 1->(65.0@30.0). 2->(65.0@115.0). 3->(171.0@48.0). 4->(154.0@154.0)} asOrderedDictionary.
self nodeSizes: { 1->(50.0@50.0). 2->(50.0@50.0). 3->(50.0@50.0). 4->(50.0@50.0)} asOrderedDictionary.
self edgeCurvatures: {(1->3)->0.(3->2)->0.(4->2)->0} asOrderedDictionary.

]

{ #category : #accessing }
EGMGraph >> nodeLocations [
	^ nodeLocations
]

{ #category : #accessing }
EGMGraph >> nodeLocations: anObject [
	nodeLocations := anObject
]

{ #category : #accessing }
EGMGraph >> nodeSizes [
	^ nodeSizes
]

{ #category : #accessing }
EGMGraph >> nodeSizes: anObject [
	nodeSizes := anObject
]

{ #category : #accessing }
EGMGraph >> nodes [
	^ nodes
]

{ #category : #accessing }
EGMGraph >> nodes: obj [
	nodes := obj.
]

{ #category : #accessing }
EGMGraph >> places [
	^ places
]

{ #category : #accessing }
EGMGraph >> places: anObject [
	places := anObject
]

{ #category : #'public interface' }
EGMGraph >> predecessorOf: aNode [
"test"
	^(self edges select: [ :edge | edge value = aNode ]) collect: [ :edge | edge key ]


]

{ #category : #accessing }
EGMGraph >> selectedNode [
	^ selectedNode
]

{ #category : #accessing }
EGMGraph >> selectedNode: anObject [
	selectedNode := anObject
]

{ #category : #'public interface' }
EGMGraph >> successorOf: aNode [
	^(self edges select: [ :edge | edge key = aNode ]) collect: [ :edge | edge value ]
]

{ #category : #accessing }
EGMGraph >> tokens [
	^ tokens
]

{ #category : #accessing }
EGMGraph >> tokens: anObject [
	tokens := anObject
]

{ #category : #accessing }
EGMGraph >> transitions [
	^ transitions
]

{ #category : #accessing }
EGMGraph >> transitions: anObject [
	transitions := anObject
]

{ #category : #accessing }
EGMGraph >> weights [
	^ weights
]

{ #category : #accessing }
EGMGraph >> weights: anObject [
	weights := anObject
]
