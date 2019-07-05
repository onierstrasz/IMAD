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

{ #category : #running }
FSATest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	fsa := FSA eg1
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
