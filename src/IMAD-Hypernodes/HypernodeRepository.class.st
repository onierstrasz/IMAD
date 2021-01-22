Class {
	#name : #HypernodeRepository,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes'
}

{ #category : #'as yet unclassified' }
HypernodeRepository >> sampleHypernodeGraph [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add: #storageClassName -> 'HypernodeRepository';
						add: #storageMethodName -> 'sampleHypernodeGraph';
						yourself);
				yourself)
			for: 1;
		setRootFor: 1 to: 1;
		nodeForId: 1
]
