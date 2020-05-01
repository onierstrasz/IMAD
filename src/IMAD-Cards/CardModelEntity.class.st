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

{ #category : #deprecated }
CardModelEntity >> asElement [
	^ self subclassResponsibility 
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
		action: [ self description: gtDoc text ].
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
		do: [ :aWish | self name: aWish text asString ].
	^ aNameEditor
]

{ #category : #properties }
CardModelEntity >> defaultDescription [
	^ 'To do'
]

{ #category : #properties }
CardModelEntity >> defaultName [
	^ 'Unknown'
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

{ #category : #generation }
CardModelEntity >> genPropertiesOn: aStream [
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

{ #category : #generation }
CardModelEntity >> genString [
	^ String streamContents: [:s | self generateOn: s]
]

{ #category : #generation }
CardModelEntity >> generateOn: aStream [
	^ self subclassResponsibility
]

{ #category : #properties }
CardModelEntity >> get: propertyKey [
	self assert: (properties includesKey: propertyKey).
	^ properties at: propertyKey ifAbsent: nil
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtDescriptionFor: aView [
	<todo: 'have a more specific announcement just for change in name or description'>
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 0;
		stencil: [ self buildDescriptionPane ];
		updateWhen: PropertiesUpdated in: [ self announcer ]
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtPropertiesFor: aView [
	"NB: A column is an instance of GtPhlowColumn"

	<gtView>
	<todo: 'fix to add new key and value'>
	<todo: 'update view on adding a new property'>
	<todo: 'update the underlying value when the key or value is edited'>
	<todo: 'add sanity checks before renaming a key!'>
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
		actionButtonIcon: BrGlamorousVectorIcons add
			action: [ self set: self freshKey to: self defaultValue ];
		updateWhen: PropertiesUpdated in: [ self announcer ];
		send: [ :assoc | assoc value ]
]

{ #category : #initialization }
CardModelEntity >> initialize [
	<todo: 'Should properties be an IdentityDictionary?'>
	super initialize.
	announcer := Announcer new.
	properties := Dictionary new.
	self name: self defaultName.
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

{ #category : #deprecated }
CardModelEntity >> open [
	"open in new window. NB: This view does not provide Inspector-like navigation."
	<todo: 'add navigation support?'>
	| aSpace |
	aSpace := BlSpace new.
	aSpace title: self name.
	aSpace extent: 800 @ 600.
	aSpace addChild: self asElement.
	aSpace withHalos.
	aSpace show
]

{ #category : #properties }
CardModelEntity >> properties [
	^ properties
]

{ #category : #properties }
CardModelEntity >> protectedKeys [
	^ { 'name' . 'description' }
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

{ #category : #'gt-extensions' }
CardModelEntity >> valueLabelFor: assoc [
	| label |
	label := BrEditableLabel new
		look:
			(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
		text: assoc value.
	label
		when: BrEditorAcceptWish
		do:
			[ :aWish | self set: assoc key to: aWish text asString ].
	^ label
]
