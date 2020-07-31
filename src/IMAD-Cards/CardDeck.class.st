"
I represent a deck of cards.
I keep track of the cards and the relations between them.

TO DO:
The implementations of cards and relations are naive to start (collections). To scale up, we will need dictionaries to quickly look up cards and their relationships.
"
Class {
	#name : #CardDeck,
	#superclass : #AbstractCardSet,
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
CardDeck >> = anObject [
	^ super = anObject
		and: [ self cards sort = anObject cards sort
				and: [ self relations sort = anObject relations sort ] ]
]

{ #category : #cards }
CardDeck >> addCard: aCard [
	cards add: aCard.
	aCard deck: self.
	self assertInvariant.
	self announcer announce: CardsUpdated new
]

{ #category : #'gt-extensions' }
CardDeck >> addCardButton [
	"NB: Still used in gtCardsFor:"
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons add;
		label: 'Add card';
		action: [ :button | 
			| card |
			card := Card new.
			self addCard: card.
			button phlow spawnObject: card ]
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
	"Add a valid relation from the first card to itself. To be edited to something useful by the user."

	self
		addRelation: '_rel' , Object new identityHash asString
		from: self cards first
		to: self cards first
]

{ #category : #relations }
CardDeck >> addRelation: aSymbol from: aSourceCard to: aTargetCard [
	| rel |
	rel := CardRelation new.
	rel initializeDeck: self kind: aSymbol source: aSourceCard target: aTargetCard.
	relations add: rel.
	self announcer announce: RelationsUpdated new.
	^ rel
]

{ #category : #'gt-extensions' }
CardDeck >> asElement [
	^ CardDeckGUI new
		deck: self;
		yourself
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
	"If this fails, there is a bug in the code generation!"

	self
		assert: self generatedDeckEqualsSelf
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
		description: 'relations must be a kind of collection'.
	self relations do: [ :each | each assertInvariant ]
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

{ #category : #relations }
CardDeck >> cardNamed: targetName become: aSymbol ofCardNamed: sourceName [
	"Convenience method"
 	self addRelation: aSymbol from: (self cardNamed: sourceName) to: (self cardNamed: targetName)
]

{ #category : #querying }
CardDeck >> cardsMatching: aFilter [
	^ CardHand new
		deck: self filter: aFilter;
		yourself
]

{ #category : #utilities }
CardDeck >> classNamed: aClassName [
	^ Smalltalk at: aClassName asSymbol ifAbsent: [ nil ]
]

{ #category : #utilities }
CardDeck >> createClassNamed: aClass subclassOf: aSuperclass inPackage: aPackage [
	^ aSuperclass , ' subclass: #' , aClass
		,
			'
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''' , aPackage , ''''
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

{ #category : #cards }
CardDeck >> deleteAllCardsAndRelations [
	self cards do: [ :each | each deck: nil ].
	cards := OrderedCollection new.
	self relations do: [ :each | each deck: nil ].
	relations := OrderedCollection new.
	self announcer announce: CardsUpdated new.
	self announcer announce: RelationsUpdated new
]

{ #category : #cards }
CardDeck >> deleteCard: aCard [
	aCard deleteRelations.
	self cards remove: aCard ifAbsent: [  ].
	self announcer announce: CardsUpdated new
]

{ #category : #'gt-extensions' }
CardDeck >> deleteCardButtonFor: aCard [
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons remove;
		label: 'Delete ', aCard name;
		action: [ :button | aCard delete ]
]

{ #category : #relations }
CardDeck >> deleteRelation: aRelation [
	self relations remove: aRelation ifAbsent: [  ].
	self announcer announce: RelationsUpdated new
]

{ #category : #'gt-extensions' }
CardDeck >> deleteRelationButtonFor: aRelation [
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons remove;
		label: 'Remove ', aRelation asString;
		action: [ :button | aRelation delete ]
]

{ #category : #printing }
CardDeck >> generateStorageMethodString [
	| stream |
	self assertValidStorageMethod.
	self assertGeneratedDeckEqualsSelf.
	stream := WriteStream on: String new.
	stream
		nextPutAll: self storageMethodName;
		nextPutAll: ' <storedCardDeck> <gtExample> ^ '.
	self storeOn: stream.
	^ OpalCompiler new format: stream contents
]

{ #category : #printing }
CardDeck >> generatedDeckEqualsSelf [
	^ (OpalCompiler new
		source: self storeString;
		evaluate) = self
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
				stencil: [ :aCard | 
					self
						editableLabelFor: aCard name
						withSetter: [ :newCardName | aCard name: newCardName ] ];
				weight: 1 ];
		column: ' '
			do: [ :column | 
			"Dummy column to enable easy clicking to next pane"
			column
				stencil: [ BlTextElement new text: '' asRopedText ];
				weight: 1 ];
		column: ' '
			do: [ :column | 
			column
				stencil: [ :aCard | self deleteCardButtonFor: aCard ];
				noWidth ];
		actionStencil: [ self addCardButton ];
		"actionStencil: [ :aTab | self refreshButtonFor: aTab ];"
			updateWhen: CardsUpdated in: [ self announcer ];
		send: [ :aCard | aCard ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtInspectorWindowFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		forViewDefinedIn: #gtDescriptionFor:;
		priority: 50;
		tooltip: 'New inspector window';
		action: [ :button | self inspect ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		title: 'Live';
		priority: 5;
		stencil: [ self asElement ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtRelationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Relations';
		priority: 40;
		items: [ self relations sort ];
		column: 'Source'
			do: [ :column | 
			column
				stencil: [ :relation | 
					self
						editableLabelFor: relation source
						withSetter: [ :arg | relation source: (self cardNamed: arg) ] ];
				weight: 1 ];
		column: 'Relation'
			do: [ :column | 
			column
				stencil: [ :relation | 
					self
						editableLabelFor: relation kind
						withSetter: [ :arg | relation kind: arg ] ];
				weight: 1 ];
		column: 'Target'
			do: [ :column | 
			column
				stencil: [ :relation | 
					self
						editableLabelFor: relation target
						withSetter: [ :arg | relation target: (self cardNamed: arg) ] ];
				weight: 1 ];
		column: ' '
			do: [ :column | 
			column
				stencil: [ BlTextElement new text: '' asRopedText ];
				weight: 1 ];
		column: ' '
			do: [ :column | 
			column
				stencil: [ :aRelation | self deleteRelationButtonFor: aRelation ];
				noWidth ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add relation';
				action: [ self addDummyRelation ] ];
		"actionStencil: [ :aTab | self refreshButtonFor: aTab ];"
			updateWhen: RelationsUpdated in: [ self announcer ];
		updateWhen: CardsUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtSaveActionFor: anAction [
	<gtAction>
	^ anAction dropdown
		icon: BrGlamorousIcons save;
		forViewDefinedIn: #gtDescriptionFor:;
		priority: 1;
		tooltip: 'Save to method ' , self storageClassMethod;
		content: [ | dropdown |
			dropdown := BlElement new
				layout: BlLinearLayout vertical;
				constraintsDo: [ :c | 
					c padding: (BlInsets all: 5).
					c vertical fitContent.
					c horizontal fitContent ];
				yourself.
			(self classNamed: self storageClassName) isClass
				ifTrue: [ self saveState.
					dropdown
						addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)) ]
				ifFalse: [ dropdown addChild: self newClassDefinitionDialog ].
			dropdown ]
]

{ #category : #'gt-extensions' }
CardDeck >> gtSaveSerializedActionFor: anAction [
	"Copy save action to serialized tab as well"

	<gtAction>
	^ (self gtSaveActionFor: anAction)
		forViewDefinedIn: #gtStoreStringFor:
]

{ #category : #'gt-extensions' }
CardDeck >> gtStoreStringFor: aView [
	"Serialized view"
	^ (super gtStoreStringFor: aView)
		updateWhen: CardsUpdated
		in: [ self announcer ]
]

{ #category : #relations }
CardDeck >> hasRelation: aSymbol [
	^ (self relationsMatching: aSymbol asRelNameFilter) isNotEmpty
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

{ #category : #'gt-extensions' }
CardDeck >> newClassDefinitionDialog [
	| container theSuperClass theClass thePackage |
	container := self newLinearLayout.
	theSuperClass := 'Object' asBrEditableLabel.
	theClass := self storageClassName asBrEditableLabel.
	thePackage := '' asBrEditableLabel.
	^ container
		addChild:
			(BrLabel new
				look: BrGlamorousLabelLook new bold;
				text: 'Please edit and create the storage class first.');
		addChild:
			(self newLinearBoxedLayout
				addChild:
					(self newFlowElement
						addChildren:
							{theSuperClass.
							' subclass: #' asBrLabel.
							theClass});
				addChild: '	instanceVariableNames: ''''' asBrLabel;
				addChild: 'classVariableNames: ''''' asBrLabel;
				addChild:
					(self newFlowElement
						addChildren:
							{'package: ''' asBrLabel.
							thePackage.
							'''' asBrLabel}));
		addChild:
			(BrButton new
				look: BrGlamorousButtonWithLabelLook;
				label: 'Create class';
				action: [ :button | 
					self storageClassName: theClass text asString.
					[ OpalCompiler new
						evaluate:
							(self
								createClassNamed: theClass text asString
								subclassOf: theSuperClass text asString
								inPackage: thePackage text asString).
					self saveState.
					container removeChildren.
					container
						addChild: (BlTextElement new text: ('Saved' asRopedText fontSize: 12)) ]
						on: Exception
						do: [ :e | self inform: e description ] ])
]

{ #category : #'gt-extensions' }
CardDeck >> newFlowElement [
	^ BlElement new
		layout: BlFlowLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #printing }
CardDeck >> saveState [
	| storageClass |
	storageClass := self classNamed: self storageClassName.
	self
		assert: storageClass isClass
		description: 'Storage class ' , self storageClassName , ' must exist.'.
	storageClass compile: self generateStorageMethodString
]

{ #category : #'gt-extensions' }
CardDeck >> show [
	BlSpace new
		addChild: self asElement;
		show
]

{ #category : #printing }
CardDeck >> storageClassMethod [
	^ self storageClassName , '>>#' , self storageMethodName
]

{ #category : #printing }
CardDeck >> storageClassName [
	^ self get: #storageClassName

]

{ #category : #printing }
CardDeck >> storageClassName: aString [
	self set: #storageClassName to: aString

]

{ #category : #printing }
CardDeck >> storageMethodName [
	^ self get: #storageMethodName
]

{ #category : #printing }
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
	self storeNameAndDescriptionOn: aStream.
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
				print: each kind;
				nextPutAll: ' fromCardNamed: ';
				print: each source name;
				nextPutAll: ' toCardNamed: ';
				print: each target name;
				nextPutAll: ';';
				cr ]
]
