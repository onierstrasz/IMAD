"
I collect some useful examples provided by the feenk team.


"
Class {
	#name : #UsefulExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards'
}

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
UsefulExamples >> coderHeaderElementForClass [
	<gtExample>
	"Example of new UI prototype for classes"
	GtClassCoderHeaderElementExamples new coderHeaderElementForClass
]

{ #category : #accessing }
UsefulExamples >> findAllTodoReferencesInAPackage [
	<gtExample>
	^ #todo: gtReferences & 'IMAD-Card' gtPackageMatches
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
						content: [ BlElement new background: Color red ]);
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
UsefulExamples >> lookSubtraction [
	<gtExample>
	"this simply means that we are not taking BrGlamorousButtonExteriorLook into account in this case, and we will get no border"
	^ BrButton new 
	look: BrGlamorousButtonWithIconLook - BrGlamorousButtonExteriorLook;
	icon: BrGlamorousIcons hamburger asElement;
	label: 'Menu'
]

{ #category : #accessing }
UsefulExamples >> openElementInOwnWindow [
<gtExample>
| aSpace |
aSpace := BlSpace new.
aSpace title: 'Space'.
aSpace extent: 1200 @ 600.
aSpace addChild: (BlElement new background: Color red).
aSpace withHalos.
aSpace show.
]

{ #category : #accessing }
UsefulExamples >> searchFilterExamples [
	<gtExample>
	^ GtSearchMethodReferencesFilterExamples
]
