"
Some test examples illustrating how property dictionaries can be stored and restored.

"
Class {
	#name : #DictionaryStorageExamples,
	#superclass : #Object,
	#category : #'IMAD-Cards-Examples'
}

{ #category : #accessing }
DictionaryStorageExamples >> assert: aDict equalsEvaluated: aStoredObject [
	self
		assert: aDict
		equals:
			(OpalCompiler new
				source: aStoredObject;
				evaluate)
]

{ #category : #accessing }
DictionaryStorageExamples >> dictionaryWithCollectionsAndNumbers [
	"flat dictionary of symbols and strings"

	<gtExample>
	| dict stored |
	dict := {(#tags -> {'foo' . 'bar'} asOrderedCollection).
	(#size -> 100)} asDictionary.
	stored := dict storeString.
	self assert: dict equalsEvaluated: stored.
	^ dict
]

{ #category : #accessing }
DictionaryStorageExamples >> dictionaryWithNestedDictionaries [
	"flat dictionary of symbols and strings"

	<gtExample>
	| dict stored |
	dict := {(
	#root -> self simpleDictionary
	
	
	)} asDictionary.
	stored := dict storeString.
	self assert: dict equalsEvaluated: stored.
	^ dict
]

{ #category : #accessing }
DictionaryStorageExamples >> simpleDictionary [
	"flat dictionary of symbols and strings"

	<gtExample>
	| dict stored |
	dict := {(#a -> 'foo').
	(#b -> 'bar').
	(#c -> 'baz')} asDictionary.
	stored := dict storeString.
	self assert: dict equalsEvaluated: stored.
	^ dict
]
