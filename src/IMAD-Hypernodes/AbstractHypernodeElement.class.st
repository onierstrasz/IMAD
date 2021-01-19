"
I hold some common, useful behaviour shared by the Hypernode view classes.
"
Class {
	#name : #AbstractHypernodeElement,
	#superclass : #BlElement,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
AbstractHypernodeElement >> defaultMargin [
	^ self defaultPadding
]

{ #category : #accessing }
AbstractHypernodeElement >> defaultPadding [
	^ 2
]

{ #category : #accessing }
AbstractHypernodeElement >> inDebugMode [
	"Use this to enable various features useful for debugging."

	^ true
]
