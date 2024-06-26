"
I'm a {{gtClass:BlPullHandler}} that does not listen to CTRL events (so they can be handled by the {{gtClass:HyperlinkDragHandler}} instead).

AS says:

in the future if you see that you have another case when you would like to prevent an existing event handler from handling events based on some condition you can decorate that event handler with an event handler decorator that checks the condition and then forwards the event if condition is met. Something like {{gtClass:name=BlEventForwarder}}.

ON: I looked but do not see how that would be simpler ...



"
Class {
	#name : #HypernodePullHandler,
	#superclass : #BlPullHandler,
	#instVars : [
		'hypernodeElement'
	],
	#category : #'IMAD-Hypernodes-View'
}

{ #category : #accessing }
HypernodePullHandler class >> for: aHypernodeElement [
	^ self new
		element: aHypernodeElement;
		yourself
]

{ #category : #accessing }
HypernodePullHandler >> context [
	^ hypernodeElement context
]

{ #category : #accessing }
HypernodePullHandler >> dragEndEvent: anEvent [
	| newPosition |
	super dragEndEvent: anEvent.
	"anEvent consumed: true."
	self assert: self context isNotNil.
	newPosition := self element constraints position.
	"self halt."
	self context reposition: newPosition
]

{ #category : #accessing }
HypernodePullHandler >> element [
	^ hypernodeElement
]

{ #category : #accessing }
HypernodePullHandler >> element: aHypernodeElement [
	self assert: aHypernodeElement isNotNil.
	hypernodeElement := aHypernodeElement
]

{ #category : #accessing }
HypernodePullHandler >> wantsEvent: anEvent [
	"I ignore Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl not ]
]
