"
I define the graph style for mind maps.

A mind map is (mostly) a tree of nodes with a dedicated root node. Each node contains some text, and possible more detailed information.

Nodes may be highlighted in various ways: background color, border, shape, test styling (font size, bold, italic).

"
Class {
	#name : #MindmapStyle,
	#superclass : #HNAbstractGraphStyle,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
MindmapStyle class >> styleName [
	^ 'Mindmap'
]

{ #category : #accessing }
MindmapStyle >> nodeAptitude [
	^ HNConfigurableAptitude
		configuration:
			{(#borderColor -> #black).
			(#text -> 'topic').
			(#shape -> #roundedRectangle)}
]
