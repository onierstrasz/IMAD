"
I'm a ${class:BlPullHandler}$ that does not listen to CTRL events (so they can be handled by the ${class:HyperlinkDragHandler}$ instead).

AS says:

in the future if you see that you have another case when you would like to prevent an existing event handler from handling events based on some condition you can decorate that event handler with an event handler decorator that checks the condition and then forwards the event if condition is met. Something like ${class:name=BlEventForwarder}$.

ON: I looked but do not see how that would be simpler ...



"
Class {
	#name : #HypernodePullHandler,
	#superclass : #BlPullHandler,
	#instVars : [
		'nodeContext'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HypernodePullHandler class >> for: aNodeContext [
	^ self new
		context: aNodeContext;
		yourself
]

{ #category : #accessing }
HypernodePullHandler >> context [
	^ nodeContext
]

{ #category : #accessing }
HypernodePullHandler >> context: aNodeContext [
	self assert: aNodeContext isNotNil.
	nodeContext := aNodeContext
]

{ #category : #accessing }
HypernodePullHandler >> dragEndEvent: anEvent [
	super dragEndEvent: anEvent.
	"anEvent consumed: true."
	self assert: self context isNotNil.
	self context
		position: (anEvent currentTarget globalPointToParent: anEvent position)
]

{ #category : #accessing }
HypernodePullHandler >> wantsEvent: anEvent [
	"I ignore Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl not ]
]
