Class {
	#name : #NegationFilter,
	#superclass : #AbstractFilter,
	#instVars : [
		'filter'
	],
	#category : #'IMAD-Cards-Filters'
}

{ #category : #accessing }
NegationFilter >> filter: aFilter [
	filter := aFilter
]

{ #category : #accessing }
NegationFilter >> matches: aCardModelEntity [
	^ (filter matches: aCardModelEntity) not
]

{ #category : #accessing }
NegationFilter >> positiveTags [
	^ Set new
]

{ #category : #accessing }
NegationFilter >> tagDictionaries [
	"NB: normalization is not implemented. Probably not needed if filters are generated from the GUI in DNF."

	self
		assert: (filter isKindOf: CardTagFilter)
		description: 'Tag filters should be normalized to disjunctive normal form'.
	^ OrderedCollection with: {(filter tag -> #negated)} asDictionary
]

{ #category : #accessing }
NegationFilter >> tags [
	^ filter tags
]
