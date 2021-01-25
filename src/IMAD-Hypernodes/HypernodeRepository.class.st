Class {
	#name : #HypernodeRepository,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes'
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
		addSubNode: 2 for: 1 withContextProperties: Dictionary new;
		addSubNode: 3 for: 1 withContextProperties: Dictionary new;
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
					(Dictionary new
						add: #storageClassName -> 'HypernodeRepository';
						add: #storageMethodName -> 'test1';
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

{ #category : #'as yet unclassified' }
HypernodeRepository >> test1 [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(Dictionary new
						add: #storageClassName -> 'HypernodeRepository';
						add: #storageMethodName -> 'test1';
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
