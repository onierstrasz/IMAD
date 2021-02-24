"
I will place the anchor on the border of nodes intersecting the line drawn between the centers of two nodes.

If the nodes overlap and the center line does not intersect the boundary, then the center itself will be the anchor.
I must implement  ==#globalPositionWithin:==.

The ${class:name=GtMondrianEdgeBuilder}$ will store me as the ==fromAnchorClass== (or ==toAnchorClass==) variable, and use me within its ${method:name=GtMondrianEdgeBuilder>>#edgeElementFor:from:to:}$ method.

Q Do I need to implement ==#referenceElement:relatedTo:== ?

"
Class {
	#name : #BlAnchorOnBorderAlongCenterPath,
	#superclass : #BlNearestPositionAnchor,
	#category : #'IMAD-Layout'
}

{ #category : #accessing }
BlAnchorOnBorderAlongCenterPath >> globalPositionWithin: aGeometryElement [
	"Compute and return a global position (in space) of this anchor"
	<return: #Point>


	^ self referenceElement boundsInSpace pointNearestTo: self nearestToElement boundsInSpace center
]

{ #category : #accessing }
BlAnchorOnBorderAlongCenterPath >> label [
	<return: #String>
	
	^ 'Not sure what this is used for.'
]
