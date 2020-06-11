"
I am a utility class for this package. I can run all the tests and find all the todos.

	IMAD gtExamples
	
	IMAD todos

"
Class {
	#name : #IMAD,
	#superclass : #Object,
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #accessing }
IMAD class >> deprecated [
	^ self new deprecated
]

{ #category : #accessing }
IMAD class >> deprecated2 [
	^ self new deprecated
]

{ #category : #converting }
IMAD class >> gtExamples [
	^ self new allExamples
]

{ #category : #converting }
IMAD class >> todos [
	^ self new findAllTodos
]

{ #category : #accessing }
IMAD >> allExamples [
	<gtExample>
	^ ('IMAD' gtPackageMatches & #gtExample gtReferences
		& (GtSearchMethodsInClassFilter forClass: IMAD) not) gtExamples
]

{ #category : #accessing }
IMAD >> deprecated [
	<gtExample>
	^ 'IMAD' gtPackageMatches & #deprecated: gtReferences
]

{ #category : #accessing }
IMAD >> findAllTodos [
	<gtExample>
	^ #todo: gtPragmas & 'IMAD-Card' gtPackageMatches
]

{ #category : #accessing }
IMAD >> garbageCollectionTestScript [

<todo: 'adapt this to test strategies for enabling garbage collection'>
<gtExample>

|report updateReport|
updateReport := [report := report, 'There are ', CardDeck allInstances size asString, ' instances of CardDeck, and ', Card allInstances size asString, ' instances of Card.
'.].

report := 'Initally:
'.
updateReport value.

(CardDeck gtReferences & #gtExample gtPragmas & (GtSearchMethodsInClassFilter forClass: IMAD) not) gtExamples do: #run.

report := report, '
After running all examples:
'.
updateReport value.

Smalltalk garbageCollect.

report := report, '
After garbage collection:
'.
updateReport value.

^ report

]

{ #category : #accessing }
IMAD >> loadAMT [
	<gtExample>
	^ Metacello new
		baseline: 'AMT';
		repository: 'https://github.com/artthik/ActorModelingTool';
		load
]

{ #category : #accessing }
IMAD >> loadEpic [
	<gtExample>
	^ Metacello new
		baseline: 'Epic';
		repository: 'github://vaano94/SCG_EpicGit';
		load
]

{ #category : #accessing }
IMAD >> loadForkedAMT [
	<gtExample>
	^ Metacello new
		baseline: 'AMT';
		repository: 'https://github.com/onierstrasz/ActorModelingTool';
		load
]
