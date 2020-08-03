Class {
	#name : #CardGraphStyle,
	#superclass : #Object,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
CardGraphStyle >> directedCurvedEdge [
	<todo: 'Use this to build graphs?'>
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

{ #category : #accessing }
CardGraphStyle >> initialize [
	super initialize.
	self mindmapStyle
]

{ #category : #accessing }
CardGraphStyle >> mindmapStyle [
	<todo: 'initialize mindmap defaults'>
]
