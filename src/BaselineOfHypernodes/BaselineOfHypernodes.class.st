Class {
	#name : #BaselineOfHypernodes,
	#superclass : #BaselineOf,
	#category : #BaselineOfHypernodes
}

{ #category : #accessing }
BaselineOfHypernodes >> baseline: spec [
	<todo: 'How do I specify a dependency on just the IMAD Extensions subpackage?'>
	<baseline>
	spec
		for: #common
		do: [ spec
				package: #IMAD;
				package: #'IMAD-Hypernodes' ]
]
