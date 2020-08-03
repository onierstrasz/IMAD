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
	self assert: (deck hasCardNamed: self cardOneName) not.
	
	card := Card new.
	card name: self cardOneName.
	deck addCard: card.
	
	self assert: (deck hasCardNamed: self cardOneName) .
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
	self assert: deck properties size equals: 2.
	key := deck freshKey.
	value := 'xyz'.
	self assert: (deck properties includesKey: key) not.
	deck set: key to: value.
	self assert: deck properties size equals: 3.
	self assert: (deck properties includesKey: key).
	self assert: (deck get: key) equals: value.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> addPropertyAbcToDeck [
	<gtExample>
	| deck key value |
	deck := self emptyDeck.
	self assert: deck properties size equals: 2.
	key := 'abc'.
	value := 'xyz'.
	self assert: (deck properties includesKey: key) not.
	deck set: key to: value.
	
	self assert: deck properties size equals: 3.
	self assert: (deck properties includesKey: key).
	self assert: (deck get: key) equals: value.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> addTagsToCardOne [
	<gtExample>
	| deck card |
	deck := self addCardOneToDeck.
	card := deck cardNamed: self cardOneName.
	self assert: card tags isEmpty.
	card addTag: 'm1'.
	card addTag: 'testScenario'.
	self assert: (card tags includes: 'm1').
	self assert: card tags size equals: 2.
	deck assertGeneratedDeckEqualsSelf.
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
	"Test compact interface to add cards"

	<gtExample>
	| deck card1 card2 |
	deck := self addCardTwoWithDeckAPI.
	card1 := deck cardNamed: self cardOneName.
	card2 := deck cardNamed: self cardTwoName.
	card1 become: #friend of: card2.	"can the same relationship be added multiple times?"
	self assert: (card2 hasA: #friend).
	self assert: (card1 isA: #friend).
	self assert: (card1 is: #friend of: card2).
	self assert: (deck hasRelation: #friend).
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> deckWithThreeCardCycle [
	<gtExample>
	| deck a b c |
	deck := self emptyDeck.
	a := Card new name: 'A'.
	b := Card new name: 'B'.
	c := Card new name: 'C'.
	deck
		addCard: a;
		addCard: b;
		addCard: c.
	a become: #x of: b.
	b become: #y of: c.
	c become: #z of: a.
	self assert: deck cards size equals: 3.
	self assert: deck relations size equals: 3.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> deleteFreshPropertyFromDeck [
	<gtExample>
	| deck key |
	deck := self addFreshPropertyToDeck.
	self assert: deck properties size equals: 3.
	key := 'key2'.
	self assert: (deck properties includesKey: key).
	deck removePropertyWithKey: key.
	self assert: deck properties size equals: 2.
	self assert: (deck properties includesKey: key) not.
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
CardDeckTestExamples >> removeTagInCardOne [
	<gtExample>
	| deck card |
	deck := self renameTagInCardOne.
	card := deck cardNamed: self cardOneName.
	card removeTagNamed: 'm2'.
	self assert: (card tags includes: 'm2') not.
	self assert: card tags size equals: 1.
	deck assertGeneratedDeckEqualsSelf.
	^ deck
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
CardDeckTestExamples >> renameTagInCardOne [
	<gtExample>
	| deck card |
	deck := self addTagsToCardOne.
	card := deck cardNamed: self cardOneName.
	card renameTagNamed: 'm1' to: 'm2'.
	self assert: (card tags includes: 'm1') not.
	self assert: (card tags includes: 'm2').
	self assert: card tags size equals: 2.
	deck assertGeneratedDeckEqualsSelf.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> threeCardCycleRemoved [
	<gtExample>
	| deck a |
	deck := self deckWithThreeCardCycle.
	a := deck cardNamed: 'A'.
	self assert: a sourceRelations size equals: 1.
	a sourceRelations do: [ :each | each delete ].
	self assert: a sourceRelations isEmpty.
	^ deck
]

{ #category : #accessing }
CardDeckTestExamples >> threeCardNodeRemoved [
	<gtExample>
	| deck a |
	deck := self deckWithThreeCardCycle.
	a := deck cardNamed: 'A'.
	self assert: deck cards size equals: 3.
	self assert: deck relations size equals: 3.
	a delete.	 "removes A as well as A->B and C->A"
	self assert: deck cards size equals: 2.
	self assert: deck relations size equals: 1.
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
	| deck |
	deck := self connectTwoCards.
	deck assertGeneratedDeckEqualsSelf.
	^ deck
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
