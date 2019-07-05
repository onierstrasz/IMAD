"
I test the FSA class
"
Class {
	#name : #FSATest,
	#superclass : #TestCase,
	#instVars : [
		'fsa'
	],
	#category : #'ASA-GtExperiments'
}

{ #category : #tests }
FSATest >> eg1 [
	^ FSA
		nodes: (1 to: 4)
		edges: { 1->2. 1->3. 2->3. 3->2. 3->4 }
		start: 1

]

{ #category : #running }
FSATest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	fsa := self eg1
]

{ #category : #tests }
FSATest >> testEnd [
	fsa go: 2; go: 3; go: 4.
	self assert: fsa isDead.

]

{ #category : #tests }
FSATest >> testNext [
	self assert: fsa isLive.
	self assert: fsa next equals: (OrderedCollection with: 2 with: 3)
]

{ #category : #tests }
FSATest >> testTransition [
	fsa go: 2.
	self assert: fsa isLive.
	self assert: fsa next equals: (OrderedCollection with: 3).
]
