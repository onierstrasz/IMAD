"
I serve as a common superclass for entities with a name and a description (Cards and Card Decks)
"
Class {
	#name : #AbstractCardModelNamedEntity,
	#superclass : #AbstractCardModelEntity,
	#instVars : [
		'name',
		'description'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #comparing }
AbstractCardModelNamedEntity >> = anObject [
	^ super = anObject
		and: [ self name = anObject name
				and: [ self description = anObject description ] ]
]

{ #category : #initialization }
AbstractCardModelNamedEntity >> assertInvariant [
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
AbstractCardModelNamedEntity >> buildDescriptionPane [
	| contentPane gtDoc aSaveButton |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	contentPane addChild: self buildLabel.
	contentPane addChild: self buildHeaderPane.
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
	contentPane addChild: gtDoc asElementWithoutSaveAction matchParent.
	contentPane addChild: aSaveButton.
	^ contentPane
]

{ #category : #accessing }
AbstractCardModelNamedEntity >> buildHeaderPane [
	"A placeholder for subclasses to add something."
	^ BlElement new
		height: 0;
		visibility: BlVisibility hidden;
		yourself
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> buildLabel [
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

{ #category : #properties }
AbstractCardModelNamedEntity >> defaultName [
	^ self class name, self identityHash asString
]

{ #category : #accessing }
AbstractCardModelNamedEntity >> description [
	^ description
]

{ #category : #accessing }
AbstractCardModelNamedEntity >> description: aString [
	description := aString.
	self announcer announce: PropertiesUpdated new
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> gtDescriptionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 0;
		stencil: [ self buildDescriptionPane ];
		"actionStencil: [ :aTab | self refreshButtonFor: aTab ];"
		updateWhen: PropertiesUpdated in: [ self announcer ];
		updateWhen: TagsUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> gtPropertiesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Properties';
		priority: 60;
		items: [ self properties associations sort: [ :a :b | a key <= b key ] ];
		column: 'Key'
			do: [ :column | 
			column
				stencil: [ :assoc | 
					self
						editableLabelFor: assoc key
						withSetter: [ :newKey | self rename: assoc key to: newKey ] ];
				weight: 1 ];
		column: 'Value'
			do: [ :column | 
			column
				stencil: [ :assoc | 
					self
						editableLabelFor: assoc value
						withSetter: [ :newValue | self set: assoc key to: newValue ] ];
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
				stencil: [ :assoc | self removePropertyButtonFor: assoc ];
				noWidth ];
		actionStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons add;
				label: 'Add property';
				action: [ self set: self freshKey to: self defaultValue ] ];
		"actionStencil: [ :aTab | self refreshButtonFor: aTab ];"
			updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> gtStoreStringFor: aView [
	<gtView>
	^ aView explicit
		title: 'Serialized';
		priority: 80;
		stencil: [ (GtPharoSnippetCoder new forSource: self storeString) asElement
				matchParent ];
		"actionStencil: [ :aTab | self refreshButtonFor: aTab ];"
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #comparing }
AbstractCardModelNamedEntity >> hash [
	^ super hash bitXor: self name hash
]

{ #category : #initialization }
AbstractCardModelNamedEntity >> initialize [
	super initialize.
	name := self defaultName.
	description := self defaultDescription
]

{ #category : #accessing }
AbstractCardModelNamedEntity >> name [
	^ name
]

{ #category : #accessing }
AbstractCardModelNamedEntity >> name: aString [
	name := aString.
	self announcer announce: PropertiesUpdated new
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> newLinearBoxedLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		look: BrGlamorousInputFieldSpacingLook;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ]
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> newLinearLayout [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #printing }
AbstractCardModelNamedEntity >> printOn: aStream [
	aStream
		nextPutAll: self name
]

{ #category : #properties }
AbstractCardModelNamedEntity >> protectedKeys [
	^ super protectedKeys
		addAll: {'name' . 'description'};
		yourself
]

{ #category : #'gt-extensions' }
AbstractCardModelNamedEntity >> removePropertyButtonFor: anAssociation [
	^ BrButton new
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousVectorIcons remove;
		label: 'Remove ', anAssociation key;
		action: [ :button | self removePropertyWithKey: anAssociation key  ]
]

{ #category : #printing }
AbstractCardModelNamedEntity >> storeNameAndDescriptionOn: aStream [
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
