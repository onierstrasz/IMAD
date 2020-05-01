"
I represent a deck of cards.
I keep track of the cards and the relations between them.

TO DO:
The implementations of cards and relations are naive to start (collections). To scale up, we will need dictionaries to quickly look up cards and their relationships.
"
Class {
	#name : #CardDeck,
	#superclass : #CardModelEntity,
	#instVars : [
		'cards',
		'relations'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
CardDeck >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ self cards = anObject cards
		and: [ self relations = anObject relations ]
]

{ #category : #cards }
CardDeck >> addCard: aCard [
	cards add: aCard.
	aCard deck: self.
	self announcer announce: CardsUpdated new
]

{ #category : #cards }
CardDeck >> addCardNamed: cardName description: cardDescription [
	self addCard: (
		Card new
			name: cardName;
			description: cardDescription;
			yourself
		)
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	| rel |
	rel := CardRelation new.
	rel name: aSymbol;
		source: aSourceCard;
		target: aTargetCard.
	relations add: rel.
	^ rel
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #cards }
CardDeck >> cardNamed: aString [
	"In general there is nothing to prohibit multiple cards with the same name, but using this method makes a strong assumption that the card exists and is uniquely named.
	(Is this a good idea?)"

	| result |
	result := self cardsNamed: aString.
	self assert: result size equals: 1.
	^ result at: 1
]

{ #category : #relations }
CardDeck >> cardNamed: targetName become: aSymbol ofCardNamed: sourceName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #cards }
CardDeck >> cards [
	^ cards
]

{ #category : #cards }
CardDeck >> cardsNamed: aString [
	^ cards select: [:each | each name = aString]
]

{ #category : #printing }
CardDeck >> compileMethodString [
	"NB: the properties className and methodName must be defined"

	self storageClass compile: self generateMethodString
]

{ #category : #defaults }
CardDeck >> defaultClassName [
	"The class where this CardDeck is stored as a generating method."
	^ 'CardDeckRepository'
]

{ #category : #defaults }
CardDeck >> defaultMethodName [
	"The name of the generating method to recreate this CardDeck."
	^ 'generateCardDeck'
]

{ #category : #printing }
CardDeck >> genMethodName [
	| methodName |
	methodName := self generatingMethodName.
	self assert: methodName notNil.
	self assert: methodName isString.
	^ methodName
]

{ #category : #printing }
CardDeck >> generateMethodString [
	| stream |
	stream := WriteStream on: String new.
	stream
		nextPutAll: self genMethodName;
		nextPutAll: '  "NB: generated method"';
		nextPutAll: '  <gtExample>';
		nextPutAll: ' ^ '.
	self storeOn: stream.
	^ OpalCompiler new format: stream contents
]

{ #category : #accessing }
CardDeck >> generatingMethodName [
	^ self get: #generatingMethodName
]

{ #category : #accessing }
CardDeck >> generatingMethodName: aString [
	self set: #generatingMethodName to: aString

]

{ #category : #'gt-extensions' }
CardDeck >> gtCardsFor: aView [
	<gtView>
	<todo: 'add button to add a card'>
	<todo:
		'NB: Also update when the name of any card is updated.
	Should we register to the PropertiesUpdated announcements of each card, or instead should each card override the name: method to ask the deck''s annpuncer to announce CardsUpdated?'>
	^ aView forward
		title: 'Cards';
		priority: 1;
		object: [ cards ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons add
			label: 'Add card'
			action:
				[ "UsefulExamples new openTextInOwnWindow: 'add a new card' " self addCard: Card new ];
		"If you need more buttons, use actionStencil:"
			updateWhen: CardsUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtRelationsFor: aView [
	<gtView>
	^ aView forward
		title: 'Relations';
		priority: 2;
		object: [ relations ];
		view: #gtItemsFor:
]

{ #category : #'gt-extensions' }
CardDeck >> gtStoreStringFor: aView [
	"<gtView>"

	^ (super gtStoreStringFor: aView)
		actionButtonIcon: BrGlamorousIcons save
		label:
			'Save to method ' , self storageClassName , '>>#'
				, self generatingMethodName
		action: [ :button | 
			| coder |
			coder := GtMethodCoder
				forClass: self storageClass
				source: self generateMethodString.
			coder expanded: true.
			button phlow spawnObject: coder asElement asScrollableElement ]
]

{ #category : #relations }
CardDeck >> hasRelation: aSymbol [
	^ (self relationsMatching:(CRRelNameFilter new name: aSymbol)) isNotEmpty
]

{ #category : #initialization }
CardDeck >> initialize [
	<todo:
		'Instead of OrderedCollections, we will need more clever implementations for cards and relations.'>
	super initialize.
	cards := OrderedCollection new.
	relations := OrderedCollection new.
	self storageClassName: self defaultClassName.
	self generatingMethodName: self defaultMethodName
]

{ #category : #initialization }
CardDeck >> invariant [
	<todo: 'call this from somewhere'>
	^ self properties isNotNil
		and: [ self cards isNotNil and: [ self relations isNotNil ] ]
]

{ #category : #querying }
CardDeck >> isEmpty [
	^ cards isEmpty
]

{ #category : #todos }
CardDeck >> listTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]

{ #category : #relations }
CardDeck >> relations [
	<todo: 'hide this behind a Facade?'>
	^ relations
]

{ #category : #querying }
CardDeck >> relationsMatching: aFilter [
	^ relations select: [:rel | aFilter matches: rel].
]

{ #category : #printing }
CardDeck >> save [
	"store the deck by generating a method that will recreate it"
	^ self compileMethodString
]

{ #category : #cards }
CardDeck >> size [
	^ cards size
]

{ #category : #printing }
CardDeck >> storageClass [
	| className storageClass |
	className := self storageClassName.
	self assert: className notNil.
	storageClass := OpalCompiler new evaluate: className.
	self assert: storageClass notNil.
	self assert: storageClass isClass.
	^ storageClass
]

{ #category : #accessing }
CardDeck >> storageClassName [
	^ self get: #storageClassName

]

{ #category : #accessing }
CardDeck >> storageClassName: aString [
	self set: #storageClassName to: aString

]

{ #category : #printing }
CardDeck >> storeCardsOn: aStream [
	self cards
		do: [ :each |
			aStream
				nextPutAll: '  addCard: ('.
			each storeOn: aStream.
			aStream
				nextPutAll: ');';
				cr.
		]
]

{ #category : #printing }
CardDeck >> storeOn: aStream [
	aStream
		nextPutAll: 'CardDeck new';
		cr.
	self storePropertiesOn: aStream.
	self storeCardsOn: aStream.
	self storeRelationsOn: aStream.
	aStream
		nextPutAll: '  yourself'
]

{ #category : #printing }
CardDeck >> storeRelationsOn: aStream [
	self relations
		do: [ :each | 
			aStream
				nextPutAll: '  addRelation: ';
				print: each name;
				nextPutAll: ' fromCardNamed: ';
				print: each source name;
				nextPutAll: ' toCardNamed: ';
				print: each target name;
				nextPutAll: ';';
				cr ]
]
