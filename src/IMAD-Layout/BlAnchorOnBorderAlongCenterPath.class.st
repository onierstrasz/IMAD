"
I will place the anchor on the border of nodes intersecting the line drawn between the centers of two nodes.

If the nodes overlap and the center line does not intersect the boundary, then the center itself will be the anchor.

Q Do I need to implement #referenceElement:relatedTo: ?

"
Class {
	#name : #BlAnchorOnBorderAlongCenterPath,
	#superclass : #BlAnchorRelativeToElement,
	#category : #'IMAD-Layout'
}
