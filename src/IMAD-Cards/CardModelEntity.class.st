"
I serve as a common superclass for shared behaviour of Card model entities.
(Prehaps I should be better factored out into traits.)
"
Class {
	#name : #CardModelEntity,
	#superclass : #Object,
	#category : #'IMAD-Cards-Model'
}

{ #category : #printing }
CardModelEntity >> genString [
	^ String streamContents: [:s | self generateOn: s]
]
