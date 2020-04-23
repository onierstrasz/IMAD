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

{ #category : #gui }
CardDeckElement >> buildTabs [
	<gtExample>
	<todo: 'add tabs for cards and relations'>
	<todo: 'add a graph view tab'>
	tabs := super buildTabs.
	tabs addTab: self cardsTab.
	tabs addTab: self relationsTab.
	^ tabs
]

{ #category : #gui }
CardDeckElement >> cardsTab [
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Cards';
		stencil: [ (self entity gtCardsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | e ] ]
]

{ #category : #initialization }
CardDeckElement >> initialize [
	super initialize.
	self entity: CardDeck new. "placeholder"
]

{ #category : #gui }
CardDeckElement >> relationsTab [
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Relations';
		stencil: [ (self entity gtRelationsFor: GtPhlowEmptyView new)
				asElementDo: [ :e | e ] ]
]
