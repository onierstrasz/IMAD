Class {
	#name : #HypernodeExamples,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodeExamples >> emptyNode [
	<gtExample>
	|eg|
	eg := Hypernode new.
	self assert: eg nodes isEmpty.
	^ eg
]

{ #category : #accessing }
HypernodeExamples >> flatGraphTwoNodes [
	<gtExample>
	| root a b |
	root := self emptyNode.
	a := root addNode.
	b := root addNode.
	root addLink: a -> b.
	^ root
]
