"
[[[
IMADSlideShow new openInSpace
]]]


"
Class {
	#name : #IMADSlideShow,
	#superclass : #GtSlideShowStencil,
	#category : #'IMAD-Cards-Presenter'
}

{ #category : #accessing }
IMADSlideShow >> create [
	| show |
	show := GtSlideShow new.
	show addSlide: (GtTitleSlide new titleText: (self title: 'IMAD')).
	^ show
]
