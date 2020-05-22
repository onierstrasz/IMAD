"
I serve as a common superclass for shared behaviour of Card model entities with a name and a description.

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

{ #category : #accessing }
CardModelNamedEntity >> announcer [
	^ announcer
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

{ #category : #utilities }
CardModelNamedEntity >> classNamed: aClassName [
	^ Smalltalk at: aClassName asSymbol ifAbsent: [ nil ]
]

{ #category : #utilities }
CardModelNamedEntity >> createClassNamed: aClass subclassOf: aSuperclass inPackage: aPackage [
	^ aSuperclass , ' subclass: #' , aClass
		,
			'
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''' , aPackage , ''''
]

{ #category : #accessing }
CardModelNamedEntity >> description [
	^ description
]

{ #category : #accessing }
CardModelNamedEntity >> description: aString [
	description := aString
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
CardModelNamedEntity >> freshKey [
	| index key |
	index := self properties size.
	key := 'key' , index asString.
	[ self properties includesKey: key ]
		whileTrue: [ index := index + 1.
			key := 'key' , index asString ].
	^ key
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
	^ self name hash
]

{ #category : #'ui requests' }
CardModelNamedEntity >> inform: aString [
	"NB: just a placeholder for a real gt version of #inform:"

	<todo: 'Build a better implementation of #inform:'>
	| aSpace |
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aString asRopedText).
	aSpace withHalos.
	aSpace show
]

{ #category : #initialization }
CardModelNamedEntity >> initialize [
	super initialize.
	self name: self freshName.
	self description: self defaultDescription
]

{ #category : #accessing }
CardModelNamedEntity >> name [
	^ name
]

{ #category : #accessing }
CardModelNamedEntity >> name: aString [
	name := aString
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
		"addAll: {'name' . 'description'};
		yourself"
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
	<todo: 'implement delete property'>
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
		nextPutAll: ';'.
	aStream cr
]

{ #category : #printing }
CardModelNamedEntity >> storePropertiesOn: aStream [
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
