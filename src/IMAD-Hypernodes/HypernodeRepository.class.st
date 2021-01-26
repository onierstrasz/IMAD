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
						add: #storageMethodName -> 'sampleHypernodeGraph';
						yourself);
				yourself)
			for: 1;
		addNode: Hypernode new yourself for: 2;
		addNode: Hypernode new yourself for: 3;
		addNode: Hypernode new yourself for: 4;
		addNode: Hypernode new yourself for: 5;
		addNode: Hypernode new yourself for: 6;
		addNode: Hypernode new yourself for: 7;
		addNode: Hypernode new yourself for: 8;
		addNode: Hypernode new yourself for: 9;
		addSubNode: 2
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (286.83984375 @ 79.0699462890625);
				yourself);
		addSubNode: 3
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (303.7421875 @ 138.9136962890625);
				yourself);
		addSubNode: 4
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (217.9140625 @ 254.9918212890625);
				yourself);
		addSubNode: 5
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (406.44921875 @ 189.3316650390625);
				yourself);
		addSubNode: 6
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (270.711672008547 @ 191.93064319577988);
				yourself);
		addSubNode: 7
			for: 1
			withContextProperties:
			(Dictionary new
				add: #position -> (312.6459134615384 @ 227.72089426415596);
				yourself);
		addSubNode: 8
			for: 2
			withContextProperties:
			(Dictionary new
				add: #position -> (169.37109375 @ 162.6480712890625);
				yourself);
		addSubNode: 9
			for: 2
			withContextProperties:
			(Dictionary new
				add: #position -> (298.90625 @ 182.7496337890625);
				yourself);
		addEdgeFrom: 5
			to: 4
			for: 1
			withProperties: Dictionary new;
		addEdgeFrom: 6
			to: 7
			for: 1
			withProperties: Dictionary new;
		setRootFor: 1 to: 1;
		setRootFor: 2 to: 1;
		setRootFor: 3 to: 1;
		setRootFor: 4 to: 1;
		setRootFor: 5 to: 1;
		setRootFor: 6 to: 1;
		setRootFor: 7 to: 1;
		setRootFor: 8 to: 1;
		setRootFor: 9 to: 1;
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
