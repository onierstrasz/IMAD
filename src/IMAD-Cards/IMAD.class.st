"
I am a utility class for this package. I can run all the tests and find all the todos.

	IMAD gtExamples
	
	IMAD todos

"
Class {
	#name : #IMAD,
	#superclass : #Object,
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #converting }
IMAD class >> gtExamples [
	^ self new allExamples
]

{ #category : #converting }
IMAD class >> todos [
	^ self new findAllTodos
]

{ #category : #accessing }
IMAD >> allExamples [
	<gtExample>
	^ ('IMAD' gtPackageMatches & #gtExample gtReferences
		& (GtSearchMethodsInClassFilter forClass: IMAD) not) gtExamples
]

{ #category : #accessing }
IMAD >> findAllTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]

{ #category : #accessing }
IMAD >> imadDesignCardDeck [
	<gtExample>
	^ CardDeck new
		name: 'IMAD Design';
		description:
			'This deck one the one hand documents the IMAD prototype design, to-dos and pending topics, and on the other hand serves as a test  case for IMAD itself.

How to load IMAD:

PharoLightTheme beCurrent.
Metacello new baseline: ''IMAD''; repository: ''github://onierstrasz/IMAD/src''; load.
(''../patches/GtPhlowDropdownAction-newButtonLook.st'' asFileReference) fileIn.
Smalltalk saveAs: ''IMAD.1''.

Some decks to load:

CardDeckRepository new garageDoorRemote.

CardDeckExamples new facultyDoodleDomain.

IMAD new imadDesignCardDeck
';
		set: #storageClassName to: 'IMAD';
		set: #storageMethodName to: 'imadDesignCardDeck';
		addCard:
			(Card new
				name: 'Short term to-dos';
				description:
					'- Graph view is broken!
	- does not work for empty deck

- factor out graphWithoutClipping example
    - how to make node view a gtExample with an argument?

- create new Graph view
    - create pure Brick version
    - tags for subviews
        - add tag view filter
    - better display of text
    - button to select layouts
        - force-based layout
    - interactively create/delete cards and links

- expand Garage door example
    - states are also cards?

- BlNearestPositionBoundsAnchor stinks
    - need a better version that grows through centers?

- add Card features
    - need more property types? (lists, dictionaries?)

- instead of typing tags, select from available tags?

- look at GtHome

- Check out new tooltip API
    - https://github.com/feenkcom/gtoolkit/issues/1036';
				yourself);
		yourself
]

{ #category : #accessing }
IMAD >> loadAMT [
	<gtExample>
	^ Metacello new
		baseline: 'AMT';
		repository: 'https://github.com/artthik/ActorModelingTool';
		load
]

{ #category : #accessing }
IMAD >> loadEpic [
	<gtExample>
	^ Metacello new
		baseline: 'Epic';
		repository: 'github://vaano94/SCG_EpicGit';
		load
]

{ #category : #accessing }
IMAD >> loadForkedAMT [
	<gtExample>
	^ Metacello new
		baseline: 'AMT';
		repository: 'https://github.com/onierstrasz/ActorModelingTool';
		load
]
