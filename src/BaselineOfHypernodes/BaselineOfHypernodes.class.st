Class {
	#name : #BaselineOfHypernodes,
	#superclass : #BaselineOf,
	#category : #BaselineOfHypernodes
}

{ #category : #accessing }
BaselineOfHypernodes >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec package: #'IMAD-Hypernodes' ]
]
