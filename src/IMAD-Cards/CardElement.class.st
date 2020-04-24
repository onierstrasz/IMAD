"
I provide a view for a Card.
"
Class {
	#name : #CardElement,
	#superclass : #CardModelElement,
	#category : #'IMAD-Cards-UI'
}

{ #category : #unused }
CardElement >> buildMainMenu [
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
CardElement >> initialize [
	super initialize.
	self entity: Card new. "placeholder"
]
