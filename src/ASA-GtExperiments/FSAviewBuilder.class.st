"
I build a view of an FSA and glue it to an FSAcontroller.

	FSAviewBuilder new viewFor: FSA eg4nodes 

"
Class {
	#name : #FSAviewBuilder,
	#superclass : #Object,
	#category : #'ASA-GtExperiments'
}

{ #category : #ui }
FSAviewBuilder >> borderCircleWithLabel: aString [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlCircle new;
		size: self defaultNodeSize;
		addChild:
			(BlTextElement new
				text: aString asRopedText;
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #ui }
FSAviewBuilder >> defaultNodeSize [
	^ 20@20
]

{ #category : #ui }
FSAviewBuilder >> directedCurvedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #ui }
FSAviewBuilder >> directedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
]

{ #category : #ui }
FSAviewBuilder >> viewFor: anFSA [
	"FSA eg4nodes view"

	| mondrian controller |
	mondrian := GtMondrian new.
	mondrian nodes
		shape: [ :x | self borderCircleWithLabel: x asString ];
		with: anFSA nodes.
	mondrian edges
		shape: [ :edge | self directedCurvedEdge ];
		fromNearestTightCircle;
		toNearestTightCircle;
		connectToAll: [ :x | anFSA following: x ].
	mondrian layout circle.
	controller := FSAcontroller forModel: anFSA andView: mondrian root.
	anFSA addDependent: controller.
	^ mondrian
]
