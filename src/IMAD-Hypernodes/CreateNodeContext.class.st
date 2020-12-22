"
A new Hypernode is created at a given position.

Creation is triggered by a double-click event in the HypernodeEditor (see ${method:name=HypernodeEditor>>#handleEvents}$), and the update is propagated to the HypernodeGraphElement (see ${method:name=HypernodeGraphElement>>#subscribe}$).
"
Class {
	#name : #CreateNodeContext,
	#superclass : #HNAnnouncement,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}