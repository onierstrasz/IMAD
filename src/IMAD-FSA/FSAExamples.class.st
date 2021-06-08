"
I am a repository of FSA examples

"
Class {
	#name : #FSAExamples,
	#superclass : #Object,
	#category : #'IMAD-FSA'
}

{ #category : #examples }
FSAExamples >> fsa10nodes [
	<gtExample>
	| fsa |
	fsa := FSA
		nodes: (0 to: 10)
		edges:
			((0 to: 10)
				flatCollect: [ :x | 
					{(x -> (x * 3 \\ 10)).
					(x -> (x // 2))} ]) asOrderedCollection removeDuplicates
		start: 10.
	^ fsa
]

{ #category : #accessing }
FSAExamples >> fsa1nodeIsDead [
	<gtExample>
	| fsa |
	fsa := FSA nodes: {0} edges: {} start: 0.
	self assert: fsa isDead.
	^ fsa
]

{ #category : #accessing }
FSAExamples >> fsa2disconnectedNodesIsDead [
	<gtExample>
	| fsa |
	fsa := FSA nodes: (0 to: 1) edges: {} start: 0.
	self assert: fsa isDead.
	^ fsa
]

{ #category : #examples }
FSAExamples >> fsa4nodes [
	<gtExample>
	| fsa |
	fsa := FSA
		nodes: (1 to: 4)
		edges:
			{(1 -> 2).
			(1 -> 3).
			(2 -> 3).
			(3 -> 2).
			(3 -> 4)}
		start: 1.
	self assert: fsa isLive.
	self assert: fsa next equals: (OrderedCollection with: 2 with: 3).
	^ fsa
]

{ #category : #examples }
FSAExamples >> fsa4nodesGo2 [
	<gtExample>
	| fsa |
	fsa := self fsa4nodes.
	fsa go: 2.
	self assert: fsa isLive.
	self assert: fsa next equals: (OrderedCollection with: 3).
	^ fsa
]

{ #category : #examples }
FSAExamples >> fsa4nodesGo2Go3 [
	<gtExample>
	| fsa |
	fsa := self fsa4nodesGo2.
	fsa go: 3.
	self assert: fsa isLive.
	self assert: fsa next equals: (OrderedCollection with: 2 with: 4).
	^ fsa
]

{ #category : #examples }
FSAExamples >> fsa4nodesGo2Go3G04 [
	<gtExample>
	| fsa |
	fsa := self fsa4nodesGo2Go3.
	fsa go: 4.
	self assert: fsa isDead.
	^ fsa
]
