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
				package: #'IMAD';
				package: #'IMAD-Hypernodes';
				package: #'IMAD-Layout';
				package: #'IMAD-Cards';
				package: #'IMAD-FSA'
			"package: #'IMAD-EGM'" ]
]
