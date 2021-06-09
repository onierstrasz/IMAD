"
Example of modeling Hospital system concepts as a mindmap.
(Also a testbed for implementing graph styles.)

```
HospitalSystem new mindmap
```

"
Class {
	#name : #HospitalSystem,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-Examples'
}

{ #category : #accessing }
HospitalSystem >> mindmap [
	<storedHypernode>
	<gtExample>
	^ HypernodeBuilder new
		addNode:
			(Hypernode new
				properties:
					(KeyedTree new
						add: #storageClassName -> 'HospitalSystem';
						add: #name -> 'Hospital';
						add: #storageMethodName -> 'mindmap';
						add: #graphStyle -> 'Mindmap';
						yourself);
				yourself)
			for: 1;
		addNode:
			(Hypernode new
				properties:
					(KeyedTree new
						add: #graphStyle -> 'Default style';
						yourself);
				yourself)
			for: 2;
		addNode:
			(Hypernode new
				properties:
					(KeyedTree new
						add: #graphStyle -> 'Default style';
						yourself);
				yourself)
			for: 3;
		addNode: Hypernode new yourself for: 4;
		addSubNode: 2
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (221.05151367187477 @ 269.98370361328125);
				yourself);
		addSubNode: 3
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (392.7137451171873 @ 256.79345703125);
				yourself);
		addSubNode: 4
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (374.3026123046875 @ 391.0487060546875);
				yourself);
		addEdgeFrom: 2
			to: 3
			for: 1
			withProperties: KeyedTree new;
		addEdgeFrom: 2
			to: 4
			for: 1
			withProperties: KeyedTree new;
		setRootFor: 1 to: 1;
		setRootFor: 2 to: 1;
		setRootFor: 3 to: 1;
		setRootFor: 4 to: 1;
		nodeForId: 1
]
