Class {
	#name : #GtHomeIMADSlideShowsSection,
	#superclass : #GtHomeSection,
	#category : #'IMAD-Presenter'
}

{ #category : #accessing }
GtHomeIMADSlideShowsSection >> create [
	| sectionContainer cardsContainer |
	sectionContainer := self newSectionContainer.
	sectionContainer
		addChild: (self newSectionTitle: 'IMAD: Interactive Modeling for Agile Development').
	cardsContainer := self newCardsContainer.
	cardsContainer
		addChild:
			(self
				newShowCardWithTitle: 'Introduction to IMAD'
				slideshow: [ IMADSlideShow new create ]
				description:
					'An introduction to the IMAD project.').

	sectionContainer addChild: cardsContainer.
	^ sectionContainer
]

{ #category : #accessing }
GtHomeIMADSlideShowsSection >> openInSpace [
	BlSpace new
		title: 'Space';
		extent: 800 @ 600;
		addChild: GtHomeIMADSlideShowsSection new create;
		withHalos;
		show
]
