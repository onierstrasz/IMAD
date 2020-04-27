Class {
	#name : #FSAExamples,
	#superclass : #Object,
	#category : #'IMAD-FSA'
}

{ #category : #examples }
FSAExamples >> fsa4nodes [
	<gtExample>
	^ FSA
		nodes: (1 to: 4)
		edges: { 1->2. 1->3. 2->3. 3->2. 3->4 }
		start: 1

]
