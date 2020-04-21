"
I provide a view for a CardDeck
"
Class {
	#name : #CardDeckElement,
	#superclass : #CardModelElement,
	#category : #'IMAD-Cards-UI'
}

{ #category : #gui }
CardDeckElement >> buildMainMenu [
	<todo: 'hook in menu items'>
	<gtExample>
	"See: GtWorldElement>>#newSubSpaceButton"
	^ BrButton new 
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons hamburger asElement;
		label: 'Menu';
		margin: (BlInsets all: 5)
]

{ #category : #initialization }
CardDeckElement >> initialize [
	super initialize.
	self entity: CardDeck new. "placeholder"
]
