"
I am a graph to be rendered with Bloc
"
Class {
	#name : #SimpleGraph,
	#superclass : #Object,
	#category : #'ASA-GtExperiments'
}

{ #category : #accessing }
SimpleGraph >> display [
	<gtExample>
	| view |
	view := GtMondrian new.
	view nodes with: (1 to: 10).
	view edges connectTo: [ :x | x //2 ].
	view layout tree.
	^ view
]

{ #category : #accessing }
SimpleGraph >> displayTenLinkedNodes [
	<gtExample>
	"Simple example directly linking nodes"
	| view |
	view := GtMondrian new.
	view nodes with: (1 to: 10).
	view edges connectTo: [ :x | x //2 ].
	view layout tree.
	^ view
]
