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
	^ super = anObject
		and: [ self cards = anObject cards
				and: [ self relations = anObject relations ] ]
]

{ #category : #cards }
CardDeck >> addCard: aCard [
	cards add: aCard.
	aCard deck: self.
	self assertInvariant.
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
CardDeck >> addDummyRelation [
	self
		addRelation: '_rel' , Object new identityHash asString
		from: self cards first
		to: self cards first
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	| rel |
	rel := CardRelation new.
	rel initializeDeck: self name: aSymbol source: aSourceCard target: aTargetCard.
	relations add: rel.
	self announcer announce: RelationsUpdated new.
	^ rel
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol fromCardNamed: sourceName toCardNamed: targetName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #initialization }
CardDeck >> assertCardsUniquelyNamed [
	| duplicates |
	duplicates := self cards collect: #name.
	duplicates removeAll: duplicates asSet.
	self
		assert: duplicates isEmpty
		description: 'cards must have unique names'
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
	super assertInvariant.
	self assert: self cards isNotNil description: 'cards must be defined'.
	self
		assert: self cards isCollection
		description: 'cards must be a kind of collection'.
	self cards do: [ :each | each assertInvariant ].
	self assertCardsUniquelyNamed.
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

{ #category : #'gt-extensions' }
CardDeck >> cardElementFor: aCard [
	^ BlElement new
		layout: BlFrameLayout new;
		border: (BlBorder paint: Color black);
		geometry: BlRectangle  new;
		size: 60@40;
		addChild:
			(BlTextElement new
				text: (aCard name asRopedText fontSize: 10);
				constraintsDo: [ :c | 
					c frame horizontal alignCenter.
					c frame vertical alignCenter ];
				yourself);
		yourself
]

{ #category : #cards }
CardDeck >> cardNamed: aString [
	| result |
	result := self cardsNamed: aString.
	self
		assert: result notEmpty
		description: 'no card exists named ' , aString.
	self
		assert: result size = 1
		description: 'multiple cards exist named ' , aString.
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
CardDeck >> defaultStorageClassName [
	"The class where this CardDeck is stored as a generating method."
	^ 'CardDeckRepository'
]

{ #category : #defaults }
CardDeck >> defaultStorageMethodName [
	"The name of the generating method to recreate this CardDeck."
	^ 'generateCardDeck'
]

{ #category : #'gt-extensions' }
CardDeck >> directedCurvedEdge [
	^ BlParabollaArcElement new
		zIndex: 0;
		curvatureFraction: 0.2;
		border: (BlBorder paint: Color gray width: 2);
		toHead:
			(BlArrowheadSimpleArrow new
				border:
					(BlBorder builder
						paint: Color gray;
						width: 2;
						build))
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
	^ aView columnedList
		title: 'Cards';
		priority: 20;
		items: [ self cards sort: [ :a :b | a name <= b name ] ];
		column: 'Cards'
			do: [ :column | 
			column
				rowStencil: [ :aCard | 
					self
						editableLabelFor:
							aCard name
						withSetter: [ :newCardName | aCard name: newCardName ] ];
				matchParent ];
		column: ' '
			do: [ :column | 
			"Dummy column to enable easy clicking to next pane"
			column
				rowStencil: [ BlTextElement new text: '' asRopedText ];
				matchParent ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add card';
				action: [
					: button |
					| card |
					card := Card new.
 					 self addCard: card .
					
					
				button phlow spawnObject: 
					card
					
					] .
				
				
				
				
				];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: CardsUpdated in: [ self announcer ];
		send: [ :aCard | aCard ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtMondrianFor: aView [
	<todo:
		'
		- refresh button and updates not working (check FSA)
		- how to make the canvas equal to the space available?
		- layout needs work
		- how to label edges?
		- how to react to mouse clicks? (on nodes, edges, or outside)
		- hovering over nodes and edges?
		'>
	<gtView>
	^ aView mondrian
		title: 'Graph';
		priority: 10;
		painting: [ :m | 
			m nodes
				shape: [ :x | self cardElementFor: x ];
				with: self cards.
			m edges
				shape: [ :edge | self directedCurvedEdge ];
				fromNearestBounds;
				toNearestBounds;
				connectToAll: [ :x | x sourceRelations collect: #target ].
			m layout tree ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: RelationsUpdated in: [ self announcer ];
		updateWhen: CardsUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtRelationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Relations';
		priority: 60;
		items: [ self relations sort ];
		column: 'Relation'
			do: [ :column | 
			column
				rowStencil: [ :relation | 
					self
						editableLabelFor: relation name
						withSetter: [ :arg | relation name: arg ] ];
				matchParent ];
		column: 'Source'
			do: [ :column | 
			column
				rowStencil: [ :relation | 
					self
						editableLabelFor: relation source
						withSetter: [ :arg | relation source: (self cardNamed: arg) ] ];
				matchParent ];
		column: 'Target'
			do: [ :column | 
			column
				rowStencil: [ :relation | 
					self
						editableLabelFor: relation target
						withSetter: [ :arg | relation target: (self cardNamed: arg) ] ];
				matchParent ];
		column: ' '
			do: [ :column | 
			column
				rowStencil: [ BlTextElement new text: '' asRopedText ];
				matchParent ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add relation';
				action: [ self addDummyRelation ] ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: RelationsUpdated in: [ self announcer ];
		updateWhen: CardsUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtSaveActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons save;
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
CardDeck >> gtSaveMainActionFor: anAction [
	"Copy save action to main tab as well"

	<gtAction>
	^ (self gtSaveActionFor: anAction)
		forViewDefinedIn: #gtDescriptionFor:
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
	self storageClassName: self defaultStorageClassName.
	self storageMethodName: self defaultStorageMethodName.
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
