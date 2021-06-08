"
I am an abstract superclass for Hypernode announcements.

I hold a reference to the updated Hypernode context.

An action on view causes an update to be performed on the model.
The model creates an announcement and delivers it to all subscribed views.
Each view subscribes to announcements in a dedicated subscribe method.
NB: The subscription specifies the action to be performed.
The action retrieves the announcement with any payload as the first argument.


"
Class {
	#name : #HNAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'context'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HNAnnouncement >> context [
	^ context
]

{ #category : #accessing }
HNAnnouncement >> context: aHypernodeContext [
	context := aHypernodeContext
]
