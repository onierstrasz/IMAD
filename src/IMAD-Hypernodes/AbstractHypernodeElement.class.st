"
I hold some common, useful behaviour shared by the Hypernode view classes.
"
Class {
	#name : #AbstractHypernodeElement,
	#superclass : #BlElement,
	#instVars : [
		'debugMode'
	],
	#category : #'IMAD-Hypernodes-IMAD-Hypernodes'
}

{ #category : #accessing }
AbstractHypernodeElement >> debugMode [
	^ debugMode
]

{ #category : #accessing }
AbstractHypernodeElement >> debugMode: aBoolean [
	debugMode := aBoolean.
	self debugMode
		ifTrue: [ self debugOnActions ]
		ifFalse: [ self debugOffActions ]
]

{ #category : #accessing }
AbstractHypernodeElement >> debugOffActions [
	"Actions to perform when debug mode is turned off. Default is none."

	
]

{ #category : #accessing }
AbstractHypernodeElement >> debugOnActions [
	"Actions to perform if we are in debug mode. Hook method to be overridden by subclasses. By default empty. NB: this is called by debugMode: if set to true."
]

{ #category : #accessing }
AbstractHypernodeElement >> defaultMargin [
	^ self defaultPadding
]

{ #category : #accessing }
AbstractHypernodeElement >> defaultPadding [
	^ 2
]

{ #category : #accessing }
AbstractHypernodeElement >> initialize [
	super initialize.
	debugMode := false
]

{ #category : #accessing }
AbstractHypernodeElement >> toggleDebugMode [
	self debugMode: self debugMode not
]
