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

{ #category : #printing }
CardDeck >> assertGeneratedDeckEqualsSelf [
	"If this happens, there is a bug in the code generation!"
	self
		assert:
			(OpalCompiler new
				source: self storeString;
				evaluate) = self
		description: 'Fatal error: generated storeString is not equal to card deck'
]

{ #category : #initialization }
CardDeck >> assertInvariant [
	| duplicates |
	super assertInvariant.
	self assert: self cards isNotNil description: 'cards must be defined'.
	self
		assert: self cards isCollection
		description: 'cards must be a kind of collection'.
	self cards do: [ :each | each assertInvariant ].
	duplicates := self cards collect: #name.
	duplicates removeAll: duplicates asSet.
	self
		assert: duplicates isEmpty
		description: 'cards must have unique names'.
	self
		assert: self relations isNotNil
		description: 'relations must be defined'.
	self
		assert: self relations isCollection
		description: 'relations must be a kind of collection'
]

{ #category : #printing }
CardDeck >> assertValidStorageMethod [
	"NB: This is not part of the class invariant. Only needs to be true as a precondition for storing."
	| methodName className |
	methodName := self storageMethodName.
	self
		assert: methodName notNil
		description: 'storage method name must be defined'.
	self
		assert: methodName isString
		description: 'storage method name must be as string'.
	self
		assert:
			(methodName
				detect: [ :c | c isAlphaNumeric not ]
				ifFound: [ false ]
				ifNone: [ true ])
		description: 'storage method name must be alphanumeric'.
	className := self storageClassName.
	self
		assert: className notNil
		description: 'storage class name must be defined'.
	self
		assert: className isString
		description: 'storage class name must be a string'.
	self
		assert: (Smalltalk at: className asSymbol ifAbsent: [ nil ]) isClass
		description: 'storage class name must refer to an existing class'
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
CardDeck >> generateStorageMethodString [
	| stream |
	self assertValidStorageMethod.
	self assertGeneratedDeckEqualsSelf.
	stream := WriteStream on: String new.
	stream
		nextPutAll: self storageMethodName;
		nextPutAll: ' "NB: generated method ';
		nextPutAll: self storageClassMethod;
		nextPutAll: '. Do not modify." <gtExample> ^ '.
	self storeOn: stream.
	^ OpalCompiler new format: stream contents
]

{ #category : #'gt-extensions' }
CardDeck >> gtCardsFor: aView [
	<gtView>
	^ aView forward
		title: 'Cards';
		priority: 1;
		object: [ cards ];
		view: #gtItemsFor:;
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add card';
				action: [ self addCard: Card new ] ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
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
CardDeck >> gtSaveActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons save;
		forViewDefinedIn: #gtDescriptionFor:;
		forViewDefinedIn: #gtStoreStringFor:;
		priority: 1;
		label: 'Save to method ' , self storageClassMethod;
		action: [ :button | 
			| coder |
			coder := (self classNamed: self storageClassName) isClass
				ifTrue: [ GtMethodCoder
						forClass: (Smalltalk at: self storageClassName asSymbol ifAbsent: [ nil ])
						source: self generateStorageMethodString ]
				ifFalse: [ GtClassDefinitionCoder new
						source: (self sourceForClassNamed: self storageClassName);
						yourself ].
			coder expanded: true.
			button phlow
				spawnObject: (coder asElement asScrollableElement labeled: self storageClassMethod) ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtStoreStringFor: aView [
	^ (super gtStoreStringFor: aView)
		updateWhen: CardsUpdated
		in: [ self announcer ]
]

{ #category : #relations }
CardDeck >> hasRelation: aSymbol [
	^ (self relationsMatching:(CRRelNameFilter new name: aSymbol)) isNotEmpty
]

{ #category : #initialization }
CardDeck >> initialize [
	super initialize.
	cards := OrderedCollection new.
	relations := OrderedCollection new.
	self storageClassName: self defaultClassName.
	self storageMethodName: self defaultMethodName.
	self assertInvariant
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
	^ relations
]

{ #category : #querying }
CardDeck >> relationsMatching: aFilter [
	^ relations select: [:rel | aFilter matches: rel].
]

{ #category : #cards }
CardDeck >> size [
	^ cards size
]

{ #category : #printing }
CardDeck >> storageClassMethod [
	^ self storageClassName , '>>#' , self storageMethodName
]

{ #category : #accessing }
CardDeck >> storageClassName [
	^ self get: #storageClassName

]

{ #category : #accessing }
CardDeck >> storageClassName: aString [
	self set: #storageClassName to: aString

]

{ #category : #accessing }
CardDeck >> storageMethodName [
	^ self get: #storageMethodName
]

{ #category : #accessing }
CardDeck >> storageMethodName: aString [
	self set: #storageMethodName to: aString

]

{ #category : #printing }
CardDeck >> storeCardsOn: aStream [
	self cards
		do: [ :each | 
			aStream nextPutAll: '  addCard: ('.
			each storeOn: aStream.
			aStream
				nextPutAll: ');';
				cr ]
]

{ #category : #printing }
CardDeck >> storeOn: aStream [
	aStream
		nextPutAll: 'CardDeck new';
		cr.
	self storePropertiesOn: aStream.
	self storeCardsOn: aStream.
	self storeRelationsOn: aStream.
	aStream nextPutAll: '  yourself'
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
