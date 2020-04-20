"
I am an abstract class for various filters to query the set of relationships over cards.

I am applied to a set of relations of a card deck using Deck>>#relationsMatching:, asking each relation if I match it.
"
Class {
	#name : #CRFilter,
	#superclass : #Object,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
CRFilter >> & aCardRelFilter [
	^ CRIntersectionFilter new left: self; right: aCardRelFilter
]

{ #category : #accessing }
CRFilter >> matches: aCardRel [
	self  subclassResponsibility
]

{ #category : #accessing }
CRFilter >> | aCardRelFilter [
	^ CRUnionFilter new left: self; right: aCardRelFilter
]
