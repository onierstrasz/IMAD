"
I am an abstract superclass for Hyperlink announcements.


"
Class {
	#name : #HLAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'hyperlink'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
HLAnnouncement >> link [
	^ hyperlink
]

{ #category : #accessing }
HLAnnouncement >> link: aHyperlink [
	hyperlink := aHyperlink
]
