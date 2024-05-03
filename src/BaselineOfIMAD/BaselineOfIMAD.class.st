Class {
	#name : #BaselineOfIMAD,
	#superclass : #BaselineOf,
	#category : #BaselineOfIMAD
}

{ #category : #loading }
BaselineOfIMAD class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'IMAD' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

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
