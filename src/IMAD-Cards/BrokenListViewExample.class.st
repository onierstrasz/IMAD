"
I document a possible bug in GtPhlowColumnedListView>>#updateContent:

Inspect:

	BrokenListViewExample new myself
	
and press the ""refresh"" button.

"
Class {
	#name : #BrokenListViewExample,
	#superclass : #GtPhlowColumnedListViewExamples,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #'gt-extension' }
BrokenListViewExample >> gtAutoUpdatingListFor: aView [
	<gtView>
	^ (super gtAutoUpdatingListFor: aView)
		actionStencil: [ :aTab | 
			BrButton new
				look: BrGlamorousButtonWithIconAptitude;
				icon: BrGlamorousVectorIcons refresh;
				label: 'Refresh';
				action: [ aTab viewContentElement phlow update ] ]
]
