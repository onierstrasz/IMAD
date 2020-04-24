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
CardModelEntity >> OLDgtPropertiesFor: aView [
	"<gtView>"
	<todo: 'adjust the sizes of the rows (losing serifs on the labels)'>
	<todo: 'fix to add new key and value'>
	<todo: 'update view on adding a new property'>
	<todo: 'update the underlying value when the key or value is edited'>
	^ aView columnedTree
		title: 'Properties';
		priority: 10;
		items: [ self properties associations ];
		children: [ :each | 
			each value isDictionary
				ifTrue: [ each value associations ]
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [ :x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key'
			do: [ :column | 
			column
				item: [ :assoc | assoc key ];
				rowStencil: [ :item | 
					| label |
					label := BrEditableLabel new
						look: BrGlamorousEditableLabelLook new glamorousRegularFontAndSize;
						text: item.
					"label editor
						when: BrTextEditorModifiedEvent
						do: [ :anEvent | 
							| newKey |
							newKey := anEvent text asString.
							newKey = item
								ifFalse: [ self at: newKey put: (self removeKey: item) ] ]."
					label ] ];
		column: 'Value'
			do: [ :column | 
			column
				item: [ :assoc | assoc value ];
				matchParent ];
		send: [ :assoc | assoc value ];
		"Why does this button disappear when the veiw is reused within the live view?"
		actionButtonIcon: BrGlamorousVectorIcons add
			label: 'Add property'
			action: [ self properties at: 'to do' put: 'to do'
			"aView update" ]
]

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
CardModelEntity >> gtOLDPropertiesFor: aView [
	"<gtView>"
	^ aView forward
		title: 'Properties';
		priority: 3;
		object: [ properties ];
		view: #gtEditItemsFor:
]

{ #category : #ui }
CardModelEntity >> gtPropertiesFor: aView [
	"NB: A column is an instance of GtPhlowColumn"

	<gtView>
	<todo: 'fix to add new key and value'>
	<todo: 'update view on adding a new property'>
	<todo: 'update the underlying value when the key or value is edited'>
	^ aView columnedList
		title: 'Properties';
		priority: 10;
		items: [ self properties associations ];
		column: 'Key'
			do: [ :column | 
			column
				item: [ :assoc | assoc key ];
				matchParent ];
		column: 'Value'
			do: [ :column | 
			column
				item: [ :assoc | assoc value ];
				rowStencil: [ :item | 
					| label |
					label := BrEditableLabel new
						look:
							(BrGlamorousEditableLabelLook new
								defaultBackground: Color transparent;
								glamorousCodeFont);
						text: item.
					label
						when: BrEditorAcceptWish
						do:
							[ :aWish | "self properties at: key put: aWish text asString"
							self halt].
					label ];
				matchParent ];
		send: [ :assoc | assoc value ] "What does this do?"
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
