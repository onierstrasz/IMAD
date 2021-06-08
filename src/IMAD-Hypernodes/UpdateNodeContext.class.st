"
An existing Hypernode is moved to a new position.
The node has been dragged with the help of the HypernodePullHandler (see {{gtMethod:name=HypernodeElement>>#handleEvents}}). This will update the node's context (see {{gtMethod:name=HypernodePullHandler>>#dragEndEvent:}}, which issues the update event to the HypernodeGraphElement (see {{gtMethod:name=HypernodeGraphElement>>#subscribe}}).

"
Class {
	#name : #UpdateNodeContext,
	#superclass : #HNAnnouncement,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}
