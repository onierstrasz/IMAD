"
I serve as a common superclass for shared behaviour of Card model entities.
(Prehaps I should be better factored out into traits.)
"
Class {
	#name : #CardModelEntity,
	#superclass : #Object,
	#instVars : [
		'properties',
		'announcer'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #accessing }
CardModelEntity >> announcer [
	^ announcer
]

{ #category : #initialization }
CardModelEntity >> assertInvariant [
	self
		assert: properties isNotNil
		description: 'properties must be defined'.
	self assert: self name isNotNil description: 'name must be defined'.
	self assert: self name isString description: 'name must be a string'.
	self
		assert: self name notEmpty
		description: 'name must not be an empty string'.
	self
		assert: self description isNotNil
		description: 'description must be defined'.
	self
		assert: self description isString
		description: 'description must be a string'.
	self
		assert: self description notEmpty
		description: 'description must not be an empty string'
]

{ #category : #'gt-extensions' }
CardModelEntity >> buildDescriptionPane [
	| contentPane gtDoc aSaveButton |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	contentPane addChild: self buildLabel.
	gtDoc := GtDocument new.
	gtDoc text: self description.
	aSaveButton := BrButton new
		look: BrGlamorousButtonWithIconLook;
		visibility: BlVisibility hidden;
		icon: BrGlamorousVectorIcons accept;
		label: 'Save';
		action: [ self description: gtDoc text asString ].
	gtDoc editor
		when: BrTextEditorModifiedEvent
		do: [ :anEvent | 
			anEvent text asString = gtDoc text
				ifTrue: [ aSaveButton visibility: BlVisibility hidden ]
				ifFalse: [ aSaveButton visibility: BlVisibility visible ] ].
	contentPane addChild: gtDoc asElementWithoutSaveAction vFitContent.
	contentPane addChild: aSaveButton.
	^ contentPane
]

{ #category : #'gt-extensions' }
CardModelEntity >> buildLabel [
	"See also GtBehaviorCoderElement>>#buildClassLabel"

	| aNameEditor |
	aNameEditor := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 20);
		text: self name;
		margin: (BlInsets all: 0).
	aNameEditor
		when: BrEditorAcceptWish
		do: [ :aWish | 
			| previousName |
			previousName := self name.
			[ self name: aWish text asString ]
				on: AssertionFailure
				do: [ aNameEditor text: previousName ] ].
	^ aNameEditor
]

{ #category : #utilities }
CardModelEntity >> classNamed: aClassName [
	^ Smalltalk at: aClassName asSymbol ifAbsent: [ nil ]
]

{ #category : #properties }
CardModelEntity >> defaultDescription [
	^ 'To do'
]

{ #category : #properties }
CardModelEntity >> defaultValue [
	^ '...'
]

{ #category : #accessing }
CardModelEntity >> description [
	^ self get: #description
]

{ #category : #accessing }
CardModelEntity >> description: aString [
	self set: #description to: aString

]

{ #category : #properties }
CardModelEntity >> freshKey [
	| index key |
	index := self properties size.
	key := 'key' , index asString.
	[ self properties includesKey: key ]
		whileTrue: [ index := index + 1.
			key := 'key' , index asString ].
	^ key
]

{ #category : #properties }
CardModelEntity >> freshName [
	^ self class name, self identityHash asString
]

{ #category : #properties }
CardModelEntity >> get: propertyKey [
	self assert: (properties includesKey: propertyKey).
	^ properties at: propertyKey ifAbsent: nil
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtDescriptionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 0;
		stencil: [ self buildDescriptionPane ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtPropertiesFor: aView [
	"NB: refresh is broken due to a bug in GtPhlowColumnedListView>>#updateContent:.
	Patch as follows:
	(GtPhlowColumnedListView>>#updateContent:) removeFromSystem
	"

	<gtView>
	^ aView columnedList
		title: 'Properties';
		priority: 10;
		items: [ self properties associations ];
		column: 'Key'
			do: [ :column | 
			column
				rowStencil: [ :assoc | self keyLabelFor: assoc ];
				matchParent ];
		column: 'Value'
			do: [ :column | 
			column
				rowStencil: [ :assoc | self valueLabelFor: assoc ];
				matchParent ];
		column: ' '
			do: [ :column | 
			"Dummy column to enable easy clicking to next pane"
			column
				rowStencil: [ BrLabel new ];
				matchParent ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add property';
				action: [ self set: self freshKey to: self defaultValue ] ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtStoreStringFor: aView [
	<gtView>
	^ aView explicit
		title: 'Serialized';
		priority: 30;
		stencil: [ (GtPharoSnippetCoder new source: self storeString) asElement
				matchParent ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'ui requests' }
CardModelEntity >> inform: aString [
	"NB: just a placeholder for a real gt version of #inform:"
	| aSpace aText |
	aText := BlRopedText string: aString.
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aText).
	aSpace withHalos.
	aSpace show
]

{ #category : #initialization }
CardModelEntity >> initialize [
	super initialize.
	announcer := Announcer new.
	properties := Dictionary new.
	self name: self freshName.
	self description: self defaultDescription
]

{ #category : #'gt-extensions' }
CardModelEntity >> keyLabelFor: assoc [
	| label |
	label := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
		text: assoc key.
	label
		when: BrEditorAcceptWish
		do: [ :aWish | 
			[ self rename: assoc key to: aWish text asString ]
				on: AssertionFailure
				do: [ label text: assoc key ] ].
	^ label
]

{ #category : #accessing }
CardModelEntity >> name [
	^ self get: #name
]

{ #category : #accessing }
CardModelEntity >> name: aString [
	self set: #name to: aString

]

{ #category : #properties }
CardModelEntity >> properties [
	^ properties
]

{ #category : #properties }
CardModelEntity >> protectedKeys [
	^ { 'name' . 'description' }
]

{ #category : #'gt-extensions' }
CardModelEntity >> refreshButtonFor: aTab [
	"Add this to an actionStencil: for a view"

	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons refresh;
		label: 'Refresh';
		action: [ aTab viewContentElement phlow update ]
]

{ #category : #properties }
CardModelEntity >> rename: oldKey to: newKey [
	self assert: (self properties includesKey: oldKey).
	self assert: (self properties includesKey: newKey) not.
	self assert: (self protectedKeys includes: oldKey) not.
	self properties at: newKey put: (self properties removeKey: oldKey).
	self announcer announce: PropertiesUpdated new
]

{ #category : #properties }
CardModelEntity >> set: propertyKey to: aValue [
	self properties at: propertyKey put: aValue.
	self announcer announce: PropertiesUpdated new
]

{ #category : #utilities }
CardModelEntity >> sourceForClassNamed: aClassName [
	^ '"NB: Please create the storage class first"
Object subclass: #' , aClassName, '
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: '''''
]

{ #category : #printing }
CardModelEntity >> storePropertiesOn: aStream [
	properties
		associationsDo: [ :each | 
			aStream
				nextPutAll: '  set: ';
				print: each key;
				nextPutAll: ' to: ';
				print: each value;
				nextPutAll: ';'.
			aStream cr ]
]

{ #category : #'gt-extensions' }
CardModelEntity >> valueLabelFor: assoc [
	| label |
	label := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
		text: assoc value.
	label
		when: BrEditorAcceptWish
		do: [ :aWish | 
			| previousName |
			previousName := assoc value.
			[ self set: assoc key to: aWish text asString ]
				on: AssertionFailure
				do: [ label text: previousName ] ].
	^ label
]
