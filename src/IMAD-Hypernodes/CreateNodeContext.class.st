"
A new Hypernode is create at a given position.
"
Class {
	#name : #CreateNodeContext,
	#superclass : #HNAnnouncement,
	#instVars : [
		'context'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
CreateNodeContext >> context [
	^ context
]

{ #category : #accessing }
CreateNodeContext >> context: aHypernodeContext [
	context := aHypernodeContext
]
