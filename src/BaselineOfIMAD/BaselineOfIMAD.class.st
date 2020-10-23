Class {
	#name : #BaselineOfIMAD,
	#superclass : #BaselineOf,
	#category : #BaselineOfIMAD
}

{ #category : #baselines }
BaselineOfIMAD >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: #'IMAD-Hypergraphs';
				package: #'IMAD-Cards';
				package: #'IMAD-FSA'
			"package: #'IMAD-EGM'" ]
]
