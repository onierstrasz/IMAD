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
