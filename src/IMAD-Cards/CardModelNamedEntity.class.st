"
I serve as a common superclass for entities with a name and a description (Cards and Card Decks)
"
Class {
	#name : #CardModelNamedEntity,
	#superclass : #CardModelEntity,
	#instVars : [
		'name',
		'description'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
CardModelNamedEntity >> = anObject [
	^ super = anObject
		and: [ self name = anObject name
				and: [ self description = anObject description ] ]
]

{ #category : #initialization }
CardModelNamedEntity >> assertInvariant [
	super assertInvariant.
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
CardModelNamedEntity >> buildDescriptionPane [
	| contentPane gtDoc aSaveButton |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	contentPane addChild: self buildLabel.
	contentPane addChild: self buildHeader.
	gtDoc := GtDocument new.
	gtDoc text: self description.
	aSaveButton := BrButton new.
	aSaveButton
		look: BrGlamorousButtonWithIconLook;
		visibility: BlVisibility hidden;
		icon: BrGlamorousVectorIcons accept;
		label: 'Save';
		action: [ self description: gtDoc text asString.
			aSaveButton visibility: BlVisibility hidden ].
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

{ #category : #accessing }
CardModelNamedEntity >> buildHeader [
	"A placeholder for subclasses to add something."
	^ BlElement new
		height: 0;
		visibility: BlVisibility hidden;
		yourself
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> buildLabel [
	"See also GtBehaviorCoderElement>>#buildClassLabel"

	^ (self
		editableLabelFor: self name
		withSetter: [ :newName | self name: newName ])
		look:
			(BrGlamorousEditableLabelLook new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 20);
		margin: (BlInsets all: 0)
]

{ #category : #accessing }
CardModelNamedEntity >> description [
	^ description
]

{ #category : #accessing }
CardModelNamedEntity >> description: aString [
	description := aString.
	self announcer announce: PropertiesUpdated new
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> editableLabelFor: aString withSetter: aOneArgumentBlock [
	| label |
	label := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
		text: aString.
	label
		when: BrEditorAcceptWish
		do: [ :aWish | 
			aString ~= aWish text asString
				ifTrue: [ [ aOneArgumentBlock value: aWish text asString ]
						on: AssertionFailure
						do: [ :e | 
							label text: aString.
							self inform: e printString ] ] ].
	^ label
]

{ #category : #properties }
CardModelNamedEntity >> freshName [
	^ self class name, self identityHash asString
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> gtDescriptionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 0;
		stencil: [ self buildDescriptionPane ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #accessing }
CardModelNamedEntity >> gtInspectorWindowFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons inspect;
		forViewDefinedIn: #gtDescriptionFor:;
		priority: 50;
		label: 'New inspector window';
		action: [ :button | 
			self inspect ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> gtPropertiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Properties';
		priority: 60;
		items: [ self properties associations sort: [ :a :b | a key <= b key ] ];
		column: 'Key'
			do: [ :column | 
			column
				rowStencil: [ :assoc | 
					self
						editableLabelFor: assoc key
						withSetter: [ :newKey | self rename: assoc key to: newKey ] ];
				matchParent ];
		column: 'Value'
			do: [ :column | 
			column
				rowStencil: [ :assoc | 
					self
						editableLabelFor: assoc value
						withSetter: [ :newValue | self set: assoc key to: newValue ] ];
				matchParent ];
		column: ' '
			do: [ :column | 
			"Dummy column to enable easy clicking to next pane"
			column
				rowStencil: [ BlTextElement new text: '' asRopedText ];
				matchParent ];
		column: ' '
			do: [ :column | 
			column
				rowStencil: [ :assoc | self removePropertyButtonFor: assoc ];
				noResize ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add property';
				action: [ self set: self freshKey to: self defaultValue ] ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> gtStoreStringFor: aView [
	<gtView>
	^ aView explicit
		title: 'Serialized';
		priority: 80;
		stencil: [ (GtPharoSnippetCoder new source: self storeString) asElement
				matchParent ];
		actionStencil: [ :aTab | self refreshButtonFor: aTab ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #comparing }
CardModelNamedEntity >> hash [
	^ super hash bitXor: self name hash
]

{ #category : #initialization }
CardModelNamedEntity >> initialize [
	super initialize.
	name := self freshName.
	description := self defaultDescription
]

{ #category : #accessing }
CardModelNamedEntity >> name [
	^ name
]

{ #category : #accessing }
CardModelNamedEntity >> name: aString [
	name := aString.
	self announcer announce: PropertiesUpdated new
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> newLinearBoxedLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		look: BrGlamorousInputFieldSpacingLook;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> newLinearLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #properties }
CardModelNamedEntity >> protectedKeys [
	^ super protectedKeys
		addAll: {'name' . 'description'};
		yourself
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> refreshButtonFor: aTab [
	"Add this to an actionStencil: for a view"

	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons refresh;
		label: 'Refresh';
		action: [ aTab viewContentElement phlow update ]
]

{ #category : #'gt-extensions' }
CardModelNamedEntity >> removePropertyButtonFor: anAssociation [
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons remove;
		label: 'Remove ', anAssociation key;
		action: [ :button | self removePropertyWithKey: anAssociation key  ]
]

{ #category : #printing }
CardModelNamedEntity >> storeNameAndDescriptionOn: aStream [
	aStream
		nextPutAll: '  name: ';
		print: self name;
		nextPutAll: ';';
		cr;
		nextPutAll: '  description: ';
		print: self description;
		nextPutAll: ';';
		cr
]
