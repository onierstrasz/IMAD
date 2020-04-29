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

{ #category : #deprecated }
CardDeck >> asElement [
	| element |
	element := CardDeckElement new.
	element entity: self.
	^ element
]

{ #category : #cards }
CardDeck >> cardNamed: aString [
	| result |
	result := cards select: [:each | each name = aString].
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

{ #category : #generation }
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

{ #category : #generation }
CardDeck >> genCardsOn: aStream [
	self cards
		do: [ :each |
			aStream
				nextPutAll: '  addCard: ('.
			each generateOn: aStream.
			aStream
				nextPutAll: ');';
				cr.
		]
]

{ #category : #generation }
CardDeck >> genMethodName [
	| methodName |
	methodName := self generatingMethodName.
	self assert: methodName notNil.
	self assert: methodName isString.
	^ methodName
]

{ #category : #generation }
CardDeck >> genRelationsOn: aStream [
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

{ #category : #generation }
CardDeck >> generateMethodString [
	| stream |
	stream := WriteStream on: String new.
	stream
		nextPutAll: self genMethodName;
		nextPutAll: '  "NB: generated method"';
		nextPutAll: '  <gtExample>';
		nextPutAll: ' ^ '.
	self generateOn: stream.
	^ OpalCompiler new format: stream contents
]

{ #category : #generation }
CardDeck >> generateOn: aStream [
	aStream
		nextPutAll: 'CardDeck new';
		cr.
	self genPropertiesOn: aStream.
	self genCardsOn: aStream.
	self genRelationsOn: aStream.
	aStream
		nextPutAll: '  yourself'
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
	^ aView forward
		title: 'Cards';
		priority: 1;
		object: [ cards ];
		view: #gtItemsFor:;
		actionButtonIcon: BrGlamorousVectorIcons add
			label: 'Add card'
			action: [ UsefulExamples new openTextInOwnWindow: 'woohoo' ]
			"If you need more buttons, use actionStencil:"
]

{ #category : #deprecated }
CardDeck >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 0;
		stencil: [ self ]
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

{ #category : #relations }
CardDeck >> hasRelation: aSymbol [
	^ (self relationsMatching:(CRRelNameFilter new name: aSymbol)) isNotEmpty
]

{ #category : #initialization }
CardDeck >> initialize [
	<todo: 'Instead of OrderedCollections, we will need more clever implementations for cards and relations.'>
	super initialize.
	cards := OrderedCollection new.
	relations := OrderedCollection new.
	self storageClassName: self defaultClassName.
	self generatingMethodName: self defaultMethodName.
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

{ #category : #generation }
CardDeck >> save [
	"store the deck by generating a method that will recreate it"
	^ self compileMethodString
]

{ #category : #cards }
CardDeck >> size [
	^ cards size
]

{ #category : #generation }
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
