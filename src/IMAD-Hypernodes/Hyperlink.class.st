"
I represent an edge between Hypernodes. Unlike an edge in a normal graph, I might link to a node in another graph.

I am a model entity. My view is provided by ${class:name=HyperlinkView}$.

"
Class {
	#name : #Hyperlink,
	#superclass : #HypergraphEntity,
	#instVars : [
		'source',
		'target'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
Hyperlink class >> from: aSourceNode to: aTargetNode [ 
	^ self new from: aSourceNode to: aTargetNode 
]

{ #category : #accessing }
Hyperlink >> = anObject [
	^ super = anObject
		and:
			[ self source = anObject source and: [ self target = anObject target ] ]
]

{ #category : #accessing }
Hyperlink >> from: aSourceNode to: aTargetNode [
	self source: aSourceNode.
	self target: aTargetNode
]

{ #category : #accessing }
Hyperlink >> nodes [
	^ OrderedCollection with: self source with: self target
]

{ #category : #accessing }
Hyperlink >> printOn: aStream [
	"Placeholder version to help in debugging"

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: source hash asString;
		nextPutAll: ' -> ';
		nextPutAll: target hash asString;
		nextPutAll: ')'
]

{ #category : #accessing }
Hyperlink >> source [
	^ source
]

{ #category : #accessing }
Hyperlink >> source: aSourceNode [
	source := aSourceNode
]

{ #category : #accessing }
Hyperlink >> target [
	^ target
]

{ #category : #accessing }
Hyperlink >> target: aTargetNode [
	target := aTargetNode
]
