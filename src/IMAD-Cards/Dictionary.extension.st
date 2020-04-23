Extension { #name : #Dictionary }

{ #category : #'*IMAD-Cards' }
Dictionary >> gtEditItemsFor: aView [
	<todo: 'adjust the sizes of the rows (losing serifs on the labels)'>
	<todo: 'fix to add new key and value'>
	<todo: 'update view on adding a new property'>
	<todo: 'update the underlying value when the key or value is edited'>
	^ aView columnedTree
		title: 'Items';
		priority: 1;
		items: [ self associations ];
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
		actionButtonIcon: BrGlamorousVectorIcons add
			label: 'Add property'
			action: [ self at: 'to do' put: 'to do'
			"aView update" ]
]
