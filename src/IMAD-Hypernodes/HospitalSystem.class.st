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
						yourself);
				yourself)
			for: 1;
		addNode: Hypernode new yourself for: 2;
		addNode: Hypernode new yourself for: 3;
		addSubNode: 2
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (243.05151367187477 @ 188.98370361328125);
				yourself);
		addSubNode: 3
			for: 1
			withContextProperties:
			(KeyedTree new
				add: #position -> (392.7137451171873 @ 256.79345703125);
				yourself);
		addEdgeFrom: 2
			to: 3
			for: 1
			withProperties: KeyedTree new;
		setRootFor: 1 to: 1;
		setRootFor: 2 to: 1;
		setRootFor: 3 to: 1;
		nodeForId: 1
]
