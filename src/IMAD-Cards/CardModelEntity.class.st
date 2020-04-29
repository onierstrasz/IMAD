"
I serve as a common superclass for shared behaviour of Card model entities.
(Prehaps I should be better factored out into traits.)
"
Class {
	#name : #CardModelEntity,
	#superclass : #Object,
	#instVars : [
		'properties'
	],
	#category : #'IMAD-Cards-Model'
}

{ #category : #deprecated }
CardModelEntity >> asElement [
	^ self subclassResponsibility 
]

{ #category : #'gt-extensions' }
CardModelEntity >> buildDescriptionDoc [
	<todo: 'make the accept button appear only if there is a change'>
	| gtDoc |
	gtDoc := GtDocument new.
	gtDoc text: self description.
	^ BrTab new
		look: BrGlamorousTabLook new;
		label: 'Description';
		stencil: [ gtDoc asElementWithoutSaveAction ];
		toolbarStencil: [ BrButton new
				look: BrGlamorousButtonWithIconLook;
				icon: BrGlamorousVectorIcons accept;
				label: 'Save';
				action: [ self description: gtDoc text ] ]
]

{ #category : #'gt-extensions' }
CardModelEntity >> buildDescriptionPane [
	"See GtClassCoderElement>>#buildContentPane"

	"used by updateContent to set the container"

	| contentPane |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	"contentPane addChild: self buildTopPane."
	contentPane addChild: self buildLabel.
	contentPane addChild: self buildDescriptionDoc.
	"contentPane addChild: BrExamplesShowroom new glamorousTabs."
	^ contentPane
]

{ #category : #'gt-extensions' }
CardModelEntity >> buildLabel [
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

{ #category : #accessing }
CardModelEntity >> defaultDescription [
	^ 'To do'
]

{ #category : #accessing }
CardModelEntity >> defaultName [
	^ 'Unknown'
]

{ #category : #accessing }
CardModelEntity >> description [
	^ self get: #description
]

{ #category : #accessing }
CardModelEntity >> description: aString [
	self set: #description to: aString

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

{ #category : #accessing }
CardModelEntity >> get: propertySymbol [
	<todo: 'Should return a dedicated Null object if absent'>
	^ properties at: propertySymbol ifAbsent: nil
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtDescriptionFor: aView [
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 0;
		stencil: [ self buildDescriptionPane ]
]

{ #category : #'gt-extensions' }
CardModelEntity >> gtPropertiesFor: aView [
	"NB: A column is an instance of GtPhlowColumn"

	<gtView>
	<todo: 'fix to add new key and value'>
	<todo: 'update view on adding a new property'>
	<todo: 'update the underlying value when the key or value is edited'>
	<todo: 'add sanity checks before renaming a key!'>
	| anAnnouncer |
	anAnnouncer := Announcer new.
	^ aView columnedList
		title: 'Properties';
		priority: 10;
		items: [ self properties associations ];
		column: 'Key'
			do: [ :column | 
			column
				rowStencil: [ :assoc | 
					| label |
					label := BrEditableLabel new
						look:
							(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
						text: assoc key.
					label
						when: BrEditorAcceptWish
						do: [ :aWish | 
							"ADD SANITY CHECK!"
							self properties at: aWish text asString put: assoc value.
							self properties removeKey: assoc key ].
					label ];
				matchParent ];
		column: 'Value'
			do: [ :column | 
			column
				rowStencil: [ :assoc | 
					| label |
					label := BrEditableLabel new
						look:
							(BrGlamorousEditableLabelLook new defaultBackground: Color transparent);
						text: assoc value.
					label
						when: BrEditorAcceptWish
						do:
							[ :aWish | "ADD SANITY CHECK!" self properties at: assoc key put: aWish text asString ].
					label ];
				matchParent ];
		actionButtonIcon: BrGlamorousVectorIcons add
			action: [ properties at: 'abc' put: 'xyz'.
			"ADD SANITY CHECK"
			anAnnouncer announce: Announcement new ];
		updateWhen: Announcement in: [ anAnnouncer ];
		send: [ :assoc | "send just the value to the next pane?" assoc value ]
]

{ #category : #initialization }
CardModelEntity >> initialize [
	<todo: 'Should properties be an IdentityDictionary?'>
	super initialize.
	properties := Dictionary new.
	self name: self defaultName.
	self description: self defaultDescription.
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

{ #category : #accessing }
CardModelEntity >> properties [
	"For CardElement"
	^ properties
]

{ #category : #accessing }
CardModelEntity >> set: propertySymbol to: aValue [
	^ properties at: propertySymbol put: aValue
]
