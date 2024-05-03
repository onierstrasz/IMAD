"
I am a common abstract superclass for Hypernodes, Hyperlinks and related classes.

See {{gtClass:name=Hypernode}}.


"
Class {
	#name : #HypergraphEntity,
	#superclass : #HNPropertyHolder,
	#instVars : [
		'announcer'
	],
	#category : #'IMAD-Hypernodes-Model'
}

{ #category : #accessing }
HypergraphEntity >> announcer [
	^ announcer
]

{ #category : #invariant }
HypergraphEntity >> assertGeneratedValueEqualsSelf [
	"If this fails, there is a bug in the code generation!"

	self
		assert: self generatedValue = self
		description: 'Fatal error: generated storeString is not equal to self'
]

{ #category : #ut }
HypergraphEntity >> assertValidStorageMethod [
	"Utility. Only needs to be true as a precondition for storing."

	| methodName className |
	methodName := self storageMethodName.
	self
		assert: methodName isNotNil
		description: 'storage method name must be defined'.
	self
		assert: methodName isString
		description: 'storage method name must be a string'.
	self
		assert:
			(methodName
				detect: [ :c | c isAlphaNumeric not ]
				ifFound: [ false ]
				ifNone: [ true ])
		description: 'storage method name must be alphanumeric'.
	self
		assert: methodName first isLowercase
		description: 'storage method name must start with lower case character'.
	className := self storageClassName.
	self
		assert: className isNotNil
		description: 'storage class name must be defined'.
	self
		assert: className isString
		description: 'storage class name must be a string'.
	self
		assert: className first isUppercase
		description: 'storage class name must start with upper case character'.
	self
		assert: (Smalltalk at: className asSymbol ifAbsent: [ nil ]) isClass
		description: 'storage class name must refer to an existing class'
]

{ #category : #'gt-extension' }
HypergraphEntity >> buildDescriptionPane [
	| contentPane gtDoc aSaveButton |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	contentPane addChild: self buildHeaderPane.
	gtDoc := GtDocument new.
	gtDoc text: self description.
	aSaveButton := BrButton new.
	aSaveButton
		aptitude: BrGlamorousButtonWithIconAptitude;
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
	contentPane
		addChild: gtDoc asElementWithoutSaveAction matchParent
		as: #doc.
	contentPane addChild: aSaveButton.
	^ contentPane
]

{ #category : #'gt-extension' }
HypergraphEntity >> buildHeaderPane [
	"A placeholder for subclasses to add something."

	| header |
	header := BlElement new.
	header layout: BlLinearLayout vertical.
	header
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	header addChild: self buildLabel.
	^ header
]

{ #category : #'gt-extension' }
HypergraphEntity >> buildLabel [
	"See also GtBehaviorCoderElement>>#buildClassLabel"

	^ (self
		editableLabelFor: self name
		withSetter: [ :newName | self name: newName ])
		aptitude:
			(BrGlamorousEditableLabelAptitude new
				defaultBackground: Color transparent;
				glamorousCodeFont;
				bold;
				fontSize: 20);
		margin: (BlInsets all: 0)
]

{ #category : #utilities }
HypergraphEntity >> classNamed: aClassName [
	^ Smalltalk at: aClassName asSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
HypergraphEntity >> description [
	^ self get: #description ifAbsent: '<edit description; click checkbox below to commit>'
]

{ #category : #accessing }
HypergraphEntity >> description: aString [
	self set: #description to: aString
]

{ #category : #storing }
HypergraphEntity >> generatedValue [
	^ OpalCompiler new
		source: self storeString;
		evaluate
]

{ #category : #'gt-extension' }
HypergraphEntity >> gtDescriptionFor: aView [
"<todo: 'Does not update if the view is hidden.
https://github.com/onierstrasz/IMAD/issues/74'>
	<gtView>
	^ aView explicit
		title: 'Description';
		priority: 10;
		stencil: [ self buildDescriptionPane ];
		updateWhen: HNPropertiesUpdated in: [ self announcer ]"

	<gtView>
	^ aView textEditor
		title: 'Description';
		priority: 10;
		aptitude: BrGlamorousCodeEditorAptitude;
		text: [ self description asRopedText ];
		actionUpdateButton
]

{ #category : #utilities }
HypergraphEntity >> inform: aString [
	"NB: just a placeholder for a real gt version of #inform:"

	| aSpace |
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aString asRopedText).
	aSpace withHalos.
	aSpace show
]

{ #category : #accessing }
HypergraphEntity >> initialize [
	super initialize.
	announcer := Announcer new
]

{ #category : #accessing }
HypergraphEntity >> name [
	^ self get: #name ifAbsent: '<edit name>'
]

{ #category : #accessing }
HypergraphEntity >> name: aString [
	self set: #name to: aString
]

{ #category : #accessing }
HypergraphEntity >> set: propertyKey to: aValue [
	super set: propertyKey to: aValue.
	self announcer announce: HNPropertiesUpdated new.
	^ aValue
]

{ #category : #storing }
HypergraphEntity >> storageClassName [
	self subclassResponsibility
]

{ #category : #storing }
HypergraphEntity >> storageMethodName [
	self subclassResponsibility
]
