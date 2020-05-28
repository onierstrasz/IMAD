Class {
	#name : #BlFitOnceLayout,
	#superclass : #BlOnceLayout,
	#instVars : [
		'stoppedLayout'
	],
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #initialization }
BlFitOnceLayout >> initialize [
	super initialize.
	stoppedLayout := BlBasicLayout new
		"constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ]"
]

{ #category : #layout }
BlFitOnceLayout >> layout: anElement in: aRectangle [
	self isStopped
		ifTrue: [ ^ self stoppedLayout layout: anElement in: aRectangle ].
	self layout layout: anElement in: aRectangle
]

{ #category : #initialization }
BlFitOnceLayout >> stoppedLayout [
	^ stoppedLayout
]

{ #category : #initialization }
BlFitOnceLayout >> stoppedLayout: aBlLayout [
	stoppedLayout := aBlLayout
]
