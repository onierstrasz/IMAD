"
!The Hypernode Editor

The ${class:name=HypernodeEditor}$ provides an interface for creating and editing ${class:name=Hypernode}$ graphs.

The editor provides various tabs to explore and edit a Hypernode and the nested graphs it contains.

The ''Live'' view allows to you edit the graph contained in a nested Hypernode.

''Double click'' on the background to add a node to the graph.
''Click drag'' on the background to reposition the graph.
''Right click'' on the background to bring up the context menu for the graph.

''Double click'' on a node to open a new editor for that node.
''Click-drag'' a node to reposition it.
''Right click'' on a node to bring up the context menu for the node.

The buttons allow you to zoom in and out, zoom to fit, zoom to actual size, refresh, and save the node and all its reachable nodes to a method of a class. The first time you will be prompted to enter the desired class name. 

''NB:'' If you change name of the generated method and save it, take care to also update the ==storageMethodName== property within the method, so the Hypernode will know where to save itself.
"
Class {
	#name : #HypernodeDocumentation,
	#superclass : #Object,
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}
