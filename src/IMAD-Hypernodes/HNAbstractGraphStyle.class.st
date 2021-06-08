"
I provide an abstract interface for various Hypernode Graph Styles. 

Every Hypernode has  graph style for the nodes it contains. The default styles is just a plain graph of nodes, but there can be various styles: Mind Maps, UML class diagrams, FSAs, etc. The Graph Style object collects all the knowledge about how nodes and graphs should be displayed, and how they behave.

The graph style also determines what kind of informatin should be stored in the HypernodeContext of individual nodes. For example, in a Mind Map style, individual nodes might have a given color, border, or text style.

Similarly the parent node may store in its properties some configuration information for the graph. The graph style will determine and access this information, for example, the layout style to be used for a mindmap.

The displayed BlElements ( HypernodeElement and HypernodeGraphElement) should delegate to the graph style to know how they should be displayed and behave.

The idea is to have a few pre-packaged graph style subclasses for common styles (like mind maps and FSAs), and also to have a highly configurable style that can be specified through a GUI and stored as a property sub-tree of the parent node (or shared between multiple hypernode graphs).


"
Class {
	#name : #HNAbstractGraphStyle,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HNAbstractGraphStyle >> graphLayout [
	"Default layout for HypernodeGraphLement just fits all the nodes, and lets them be repositioned according to the positions stored in the node's contexts."

	^ BlOnceLayout new layout: BlFitLayout new
]

{ #category : #accessing }
HNAbstractGraphStyle >> nodeLayout [
	"Default layout for HypernodeElement"

	^ BlFrameLayout
		new;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]
]
