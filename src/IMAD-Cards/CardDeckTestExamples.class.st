"
I contain basic example to test the functionality of Cards and CardElements.

"
Class {
	#name : #CardDeckTestExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
CardDeckTestExamples >> addCardOneToDeck [
	<gtExample>
	| deck card |
	deck := self emptyDeck.
	self assert: (deck cardsNamed: self cardOneName) isEmpty.
	
	card := Card new.
	card name: self cardOneName.
	deck addCard: card.
	
	self assert: (deck cardsNamed: self cardOneName) size equals: 1.
	self assert: (deck cardNamed: self cardOneName) == card.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> addCardTwoWithDeckAPI [
	<gtExample>
	"Test compact interface to add cards"
	| deck card cardTwoDescription |
	cardTwoDescription := 'I am Card2'.
	deck := self addCardOneToDeck.
	deck addCardNamed: self cardTwoName description: cardTwoDescription.
	card := (deck cardNamed: self cardTwoName).

	self assert: deck size equals: 2.
	self assert: card name equals: self cardTwoName.
	self assert: card description equals: cardTwoDescription.
	
	^ deck
	
]

{ #category : #accessing }
CardDeckTestExamples >> addFreshPropertyToDeck [
	<gtExample>
	| deck key value |
	deck := self emptyDeck.
	self assert: deck properties size equals: 4.
	key := deck freshKey.
	value := 'xyz'.
	self assert: (deck properties includesKey: key) not.
	deck set: key to: value.
	self assert: deck properties size equals: 5.
	self assert: (deck properties includesKey: key).
	self assert: (deck get: key) equals: value.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> addPropertyAbcToDeck [
	<gtExample>
	| deck key value |
	deck := self emptyDeck.
	self assert: deck properties size equals: 4.
	key := 'abc'.
	value := 'xyz'.
	self assert: (deck properties includesKey: key) not.
	deck set: key to: value.
	
	self assert: deck properties size equals: 5.
	self assert: (deck properties includesKey: key).
	self assert: (deck get: key) equals: value.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> cardOneName [
	^ 'Card1'
]

{ #category : #accessing }
CardDeckTestExamples >> cardTwoName [
	^ 'Card2'
]

{ #category : #accessing }
CardDeckTestExamples >> connectTwoCards [
	<todo: 'specify relationships'>
	<gtExample>
	"Test compact interface to add cards"
	| deck card1 card2 |
	deck := self addCardTwoWithDeckAPI.
	card1 := deck cardNamed: self cardOneName.
	card2 := deck cardNamed: self cardTwoName.

	card1 become: #friend of: card2. "can the same relationship be added multiple times?"
	
	self assert: (card2 hasA: #friend).
	self assert: (card1 isA: #friend).
	self assert: (card1 is: #friend of: card2).
	
	self assert: (deck hasRelation: #friend).
	
	^ deck
	

]

{ #category : #accessing }
CardDeckTestExamples >> emptyDeck [
	<gtExample>
	| deck |
	deck := CardDeck new.
	deck
		name: 'A Test Deck';
		description: 'I hold a bunch of boring examples to test core functionality.'.
	deck
		storageClassName: 'CardDeckTestExamples';
		storageMethodName: 'genCardDeckTestExamples'.
	self assert: deck isEmpty.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> emptyDeckEqualsEmptyDeck [
	<gtExample>
	| deck1 deck2 |
	deck1 := self emptyDeck.
	deck2 := self emptyDeck.
	self assert: deck1 equals: deck2.
	^ deck1
]

{ #category : #accessing }
CardDeckTestExamples >> getCardOne [
	<gtExample>
	"Check that an added card has the right properties"
	| deck card |
	deck := self addCardOneToDeck.
	card := deck cardNamed: self cardOneName.
	self assert: card name equals: self cardOneName.
	self assert: card description equals: card defaultDescription.
	
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> initialize [
	super initialize
]

{ #category : #accessing }
CardDeckTestExamples >> oneCardDeckEqualsOneCardDeck [
	<gtExample>
	| deck1 deck2 |
	deck1 := self addCardOneToDeck.
	deck2 := self addCardOneToDeck.
	self assert: deck1 equals: deck2.
	^ deck1
]

{ #category : #accessing }
CardDeckTestExamples >> renamePropertyAbcToAbcdInDeck [
	<gtExample>
	| deck oldKey newKey value |
	deck := self addPropertyAbcToDeck.
	oldKey := 'abc'.
	newKey := 'abcd'.
	value := 'xyz'.
	self assert: (deck properties includesKey: oldKey).
	self assert: (deck properties includesKey: newKey) not.
	deck rename: oldKey to: newKey.
	self assert: (deck properties includesKey: oldKey) not.
	self assert: (deck properties includesKey: newKey).
	self assert: (deck get: newKey) equals: value.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> renameProtectedPropertyFails [
	<gtExample>
	| deck oldKey newKey value |
	deck := self addPropertyAbcToDeck.
	oldKey := 'name'.
	newKey := 'name2'.
	value := 'xyz'.
	self assert: (deck properties includesKey: oldKey).
	self assert: (deck properties includesKey: newKey) not.
	self
		assert:
			([ deck rename: oldKey to: newKey.
			false ]
				on: AssertionFailure
				do: [ true ]).
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> twoCardDeckEqualsTwoCardDeck [
	<gtExample>
	| deck1 deck2 |
	deck1 := self addCardTwoWithDeckAPI.
	deck2 := self addCardTwoWithDeckAPI.
	self assert: deck1 equals: deck2.
	^ deck1
]

{ #category : #accessing }
CardDeckTestExamples >> twoCardDeckNotEqualsOneCardDeck [
	<gtExample>
	| deck1 deck2 |
	deck1 := self addCardTwoWithDeckAPI.
	deck2 := self addCardOneToDeck.
	self assert: deck1 ~= deck2.
	^ deck1
]

{ #category : #accessing }
CardDeckTestExamples >> twoConnectedCardDeckEqualsStoreStringDeck [
	"cf twoConnectedCardDeckEqualsGeneratedDeck"

	<gtExample>
	| deck1 deck2 |
	deck1 := self connectTwoCards.
	deck2 := OpalCompiler new
		source: deck1 storeString;
		evaluate.
	self assert: deck1 equals: deck2.
	^ deck1
]

{ #category : #accessing }
CardDeckTestExamples >> twoConnectedCardDeckEqualsTwoConnectedCardDeck [
	<gtExample>
	| deck1 deck2 |
	deck1 := self connectTwoCards.
	deck2 := self connectTwoCards.
	self assert: deck1 equals: deck2.
	^ deck1
]
