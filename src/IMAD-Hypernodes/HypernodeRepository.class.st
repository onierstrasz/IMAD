Class {
	#name : #HypernodeRepository,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-Examples'
}

{ #category : #'as yet unclassified' }
HypernodeRepository >> flatGraphWithNodeProperties [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add: 'storageClassName' -> 'HypernodeRepository';
						add: #name -> 'Flat graph';
						add: #description -> 'I am a flat graph whose nodes store some properties.';
						add: 'storageMethodName' -> 'flatGraphWithNodeProperties';
						yourself);
				yourself)
			for: 1;
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add:
							#nested
								->
									((Array new: 3)
										at: 1 put: #a -> 1;
										at: 2 put: #b -> 2;
										at: 3
											put:
											#c
												->
													(Dictionary new
														add: #x -> 'hello';
														add:
															#y
																->
																	(OrderedCollection new
																		add: 'hi';
																		add: 'there';
																		yourself);
														yourself);
										yourself);
						yourself);
				yourself)
			for: 2;
		addNode: Hypernode new yourself for: 3;
		addSubNode: 2
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (38 @ 56);
				yourself);
		addSubNode: 3
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (76 @ 12);
				yourself);
		addEdgeFrom: 2
			to: 3
			for: 1
			withProperties: Dictionary new;
		setRootFor: 1 to: 1;
		setRootFor: 2 to: 1;
		setRootFor: 3 to: 1;
		nodeForId: 1
]

{ #category : #accessing }
HypernodeRepository >> sampleHypernodeGraph [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(KeyedTree new
						add: #storageClassName -> 'HypernodeRepository';
						add: #storageMethodName -> 'sampleHypernodeGraph';
						yourself);
				yourself)
			for: 1;
		addNode: Hypernode new yourself for: 2;
		addNode: Hypernode new yourself for: 3;
		addNode: Hypernode new yourself for: 4;
		addNode: Hypernode new yourself for: 5;
		addSubNode: 2
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (128.72760009765625 @ 194.53741455078125);
				yourself);
		addSubNode: 3
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (307.099365234375 @ 186.00860595703125);
				yourself);
		addSubNode: 4
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (229.5087890625 @ 296.09161376953125);
				yourself);
		addSubNode: 5
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (455.4840087890625 @ 268.706298828125);
				yourself);
		setRootFor: 1 to: 1;
		setRootFor: 2 to: 1;
		setRootFor: 3 to: 1;
		setRootFor: 4 to: 1;
		setRootFor: 5 to: 1;
		nodeForId: 1
]

{ #category : #'as yet unclassified' }
HypernodeRepository >> testGraph [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add: #storageClassName -> 'HypernodeRepository';
						add: #name -> 'Test graph';
						add: #description -> 'I serve as a simple test graph for experiments.';
						add: #storageMethodName -> 'testGraph';
						yourself);
				yourself)
			for: 1;
		addNode: Hypernode new yourself for: 2;
		addSubNode: 2
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (205.93073377981372 @ 157.1988525390625);
				yourself);
		setRootFor: 1 to: 1;
		setRootFor: 2 to: 1;
		nodeForId: 1
]
