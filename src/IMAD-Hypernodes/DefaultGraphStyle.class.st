"
I am the default graph style for graphs and nodes

"
Class {
	#name : #DefaultGraphStyle,
	#superclass : #HNAbstractGraphStyle,
	#category : #'IMAD-Hypernodes-Styles'
}

{ #category : #accessing }
DefaultGraphStyle class >> styleName [
	^ 'Default style'
]

{ #category : #accessing }
DefaultGraphStyle >> nodeAptitude [
	^ HNConfigurableAptitude
		configuration:
			{(#borderColor -> #black).
			(#hoverColor -> #red).
			(#text -> '').
			(#shape -> #circle)}
]
