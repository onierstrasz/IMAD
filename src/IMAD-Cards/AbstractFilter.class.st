"
I am an abstract class for various filters to query the set of relationships over cards.

I am applied to a set of relations of a card deck using Deck>>#relationsMatching:, asking each relation if I match it.
"
Class {
	#name : #AbstractFilter,
	#superclass : #Object,
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
AbstractFilter >> & aFilter [
	^ IntersectionFilter new
		left: self;
		right: aFilter
]

{ #category : #accessing }
AbstractFilter >> matches: aCardModelEntity [
	"I.e., a Card or a Relation"
	self  subclassResponsibility
]

{ #category : #accessing }
AbstractFilter >> not [
	^ NegationFilter new filter: self
]

{ #category : #accessing }
AbstractFilter >> positiveTags [
	"Only relevant for Tag filters. Returns the set of tags that should be set to pass the filter."

	self subclassResponsibility
]

{ #category : #accessing }
AbstractFilter >> | aFilter [
	^ UnionFilter new
		left: self;
		right: aFilter
]
