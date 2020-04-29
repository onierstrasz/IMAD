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

{ #category : #ui }
CardModelEntity >> asElement [
	^ self subclassResponsibility 
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

{ #category : #ui }
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

{ #category : #ui }
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
