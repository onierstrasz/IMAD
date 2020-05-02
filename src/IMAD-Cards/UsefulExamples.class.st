"
I collect some useful examples provided by the feenk team.


"
Class {
	#name : #UsefulExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
UsefulExamples >> attachGtDocToModel [
	<gtExample>
	| dict doc |
	dict := Dictionary new.
	dict at: #name put: 'Homer'.
	doc := GtDocument new.
	doc text: (dict at: #name).
	doc
		when: GtDocumentUpdateRequestedAnnouncement
		do: [ dict at: #name put: doc text asString ].
	"GtInspector openOn: doc."
	doc text: 'Madge'.
	doc mayRequestDocumentUpdate.
	self assert: (dict at: #name) equals: 'Madge'.
	^ doc
]

{ #category : #accessing }
UsefulExamples >> autofitElementToContainer [
	<gtExample>
	
^ BlElement new 
	layout: BlLinearLayout new;
	background: Color paleBlue;
	constraintsDo: [:c | 
		c horizontal matchParent.
		c vertical matchParent ];	
	addChild: (BlElement new 
		background: Color paleRed;
		layout: BlLinearLayout new;
		constraintsDo: [:c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addChild: (BlTextElement new text: 'something' asRopedText))
]

{ #category : #accessing }
UsefulExamples >> buildDifferentKindsOfTabs [
	<gtExample>
	<todo: 'Add more examples of different kinds of tabs.'>
	<todo: 'Add a list tab example (simpsons)'>
	| tabs |
	"Sources:
	BrExamplesShowroom>>#glamorousTabs
	"
	tabs := BrTabGroup new.
	tabs look: BrGlamorousTabGroupLook new.
		
	tabs addTab: (BrTab new
		look: BrGlamorousTabLook new;
		label: 'Text';
		stencil: [ GtDocument new text: 'Sample text']).

	tabs addTab: (BrTab new
		look: BrGlamorousTabLook new;
		label: 'BlueBox';
		stencil: [ BlElement new
			constraintsDo: [ :c |
				c horizontal matchParent.
				c vertical exact: 300 ];
			margin: (BlInsets all: 10);
			background: (Color blue alpha: 0.2) ]).

	tabs addTab: (BrTab new
		look: BrGlamorousTabLook new;
		label: 'Simpsons';
		stencil: [
			(self simpsons gtItemsFor: GtPhlowEmptyView new)
				asElementDo: [:e | e ]
			]).


	^ tabs
]

{ #category : #accessing }
UsefulExamples >> buttonWithActions [
	"Example by TG"

	<gtExample>
	^ BrButton new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		padding: (BlInsets all: 7);
		icon: BrGlamorousIcons hamburger asElement;
		look:
			BrGlamorousButtonWithIconLook
				+
					(BrGlamorousWithDropdownLook new
						stencil: [ | aList |
							aList := BrGlamorousSimpleContextMenuContent new.
							aList
								display:
									{('Action 1' -> [ 'action 1' inspect ]).
									('Action 2' -> [ self openTextInOwnWindow: 'action 2' ]).
									('Action 3' -> [ self openTextInOwnWindow: 'action 3' ])}.
							BrAnchoredElement new
								look:
									(BrGlamorousDropdownLook new
										handle:
											(BrButton new
												icon: BrGlamorousIcons hamburger asElement;
												look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook);
										content:
											(aList
												padding: (BlInsets all: 5);
												vFitContent;
												hExact: 200)) ]);
		relocate: 200 @ 100
]

{ #category : #accessing }
UsefulExamples >> coderHeaderElementForClass [
	<gtExample>
	"Example of new UI prototype for classes"
	GtClassCoderHeaderElementExamples new coderHeaderElementForClass
]

{ #category : #accessing }
UsefulExamples >> examplesExplorerForPackage [
	<gtExample>
	| baseline repo |
	baseline := BaselineOfIMAD.
	repo := 'github.com/onierstrasz/ASA-GtExperiments/src'.
 	^ (( GtRlSystemExamplesExplorer forProject:
 	(GtRlDependenciesModelBuilder new
 		buildProjectFromBaselineClass: baseline
 		withRepositoryDescription: repo)) repositoryExplorers ) at: 1
]

{ #category : #accessing }
UsefulExamples >> filterToExampleGroup [
	<gtExample>
	^ #printString gtReferences gtExamples
]

{ #category : #accessing }
UsefulExamples >> findAllTodosInAPackage [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]

{ #category : #accessing }
UsefulExamples >> findExamplesOfAClass [
	<gtExample>
	^ BrTab gtReferences & #gtExample gtPragmas
]

{ #category : #accessing }
UsefulExamples >> gtToolsMenu [
	<gtExample>
	"See GtWorldElement>>#newSubSpaceButton and GtToolsMenu"
	| menu |
	"menu := GtToolsMenu new."
	menu := BlElement new.

	"initialize"
	menu layout: BlFlowLayout new.
	menu constraintsDo: [ :c | 
			c vertical fitContent.
			c horizontal exact: 420 ].
	menu padding: (BlInsets top: 10 bottom: 10).
	
	menu removeChildren.

	menu addChild: (GtHomeToolsSection new newPlaygroundButtonStencil smallIcon create size: 100@100).
	menu addChild: (GtHomeToolsSection new newCoderButtonStencil smallIcon create  size: 100@100).
	menu addChild: (GtHomeToolsSection new newGitButtonStencil smallIcon create  size: 100@100).
	menu addChild: (GtHomeToolsSection new newMonitorButtonStencil smallIcon create  size: 100@100).
	menu addChild: (GtHomeToolsSection new newExamplesButtonStencil smallIcon create  size: 100@100).
	menu addChild: (GtHomeToolsSection new newTranscriptButtonStencil smallIcon create  size: 100@100).
	menu addChild: (GtHomeToolsSection new newMorphicWorldButtonStencil smallIcon create  size: 100@100).
		
	menu addChild: (BlElement new
		layout: (BlLinearLayout horizontal cellSpacing: 10);
		margin: (BlInsets top: 25 left: 10 bottom: 5 right: 10);
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		addChildren: {
			BrButton new
				look: BrGlamorousButtonWithLabelLook new;
				label: 'Save';
				hMatchParent;
				action: [ :aButton | aButton space universe snapshot: true andQuit: false ].
				
			BrButton new
				look: (BrGlamorousButtonWithLabelLook new);
				label: 'Quit';
				hMatchParent;
				action: [ :aButton | aButton space universe snapshot: false andQuit: true ] }).

	^ menu
]

{ #category : #accessing }
UsefulExamples >> hamburgerDropdown [
	<gtExample>
	| subSpaceDropdown |
	subSpaceDropdown := BrButton new
		look:
			BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook
				+
					(BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons hamburger asElement;
								label: 'Menu' ]
						content: [
							self gtToolsMenu
						 ]);
		icon: BrGlamorousIcons hamburger asElement;
		label: 'Menu';
		yourself.
	^ subSpaceDropdown
]

{ #category : #accessing }
UsefulExamples >> hamburgerWithIconLook [
	<gtExample>
	^ BrButton new 
	look: BrGlamorousButtonWithIconLook;
	icon: BrGlamorousIcons hamburger asElement;
	label: 'Menu'
]

{ #category : #accessing }
UsefulExamples >> hamburgerWithLabelLook [
	<gtExample>
	^ BrButton new 
	look: BrGlamorousButtonWithLabelLook;
	icon: BrGlamorousIcons hamburger asElement;
	label: 'Menu'
]

{ #category : #accessing }
UsefulExamples >> johnDoeContact [
	<gtExample>
	^ GtABAddressBookExample new johnDoeContact
]

{ #category : #accessing }
UsefulExamples >> lookSubtraction [
	<gtExample>
	"this simply means that we are not taking BrGlamorousButtonExteriorLook into account in this case, and we will get no border"
	^ BrButton new 
	look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook;
	icon: BrGlamorousIcons hamburger asElement;
	label: 'Menu'
]

{ #category : #utilities }
UsefulExamples >> openTextInOwnWindow: aString [
	| aSpace aText |
	aText := BlRopedText string: aString.
	aSpace := BlSpace new.
	aSpace title: aString.
	aSpace extent: 500 @ 50.
	aSpace addChild: (BlTextElement new text: aText). "NB: Could be any kind of BlElement"
	aSpace withHalos.
	aSpace show
]

{ #category : #accessing }
UsefulExamples >> paneWithTabs [
	<gtExample>
	| contentPane label |
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout vertical.
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	label := BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: 'Woohoo'.
	contentPane addChild: label.
	contentPane addChild: self buildDifferentKindsOfTabs.
	^ contentPane
]

{ #category : #accessing }
UsefulExamples >> scrollableMethodCoder [
	<gtExample>
	^ ((GtMethodCoder
		forClass: CardDeckExamples
		source: CardDeckExamples new facultyDoodleDomain generateStorageMethodString)
		expanded: true;
		asElement) asScrollableElement
]

{ #category : #accessing }
UsefulExamples >> searchFilterExamples [
	<gtExample>
	^ GtSearchMethodReferencesFilterExamples
]

{ #category : #accessing }
UsefulExamples >> simpsons [
	^ OrderedCollection with: 'Homer' with: 'Marge' with: 'Lisa' with: 'Bart' with: 'Maggie'
]

{ #category : #accessing }
UsefulExamples >> textWithMenuAtRight [
	"Adapted from BlLinearLayoutUsageExamples>>#twoChildrenOnOppositeSidesWithSpan"
	<gtExample>
	| parent left span right |
	
	parent := BlElement new.
	parent layout: (BlLinearLayout horizontal).
	parent constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical fitContent ].

	left := BrLabel new
		margin: (BlInsets left: 10);
		look: (BrGlamorousLabelLook new bold glamorousRegularFont fontSize: 20);
		text: 'Woohoo!'.
	
	span := BlElement new.
	span constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent. ].

	right := BrButton new 
		look: BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons hamburger asElement;
		label: 'Menu'.

	parent addChildren: { left . span . right }.

	^ parent
]
