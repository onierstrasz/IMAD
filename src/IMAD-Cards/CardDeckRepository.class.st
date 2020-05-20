Class {
	#name : #CardDeckRepository,
	#superclass : #Object,
	#category : #'IMAD-Cards-CardDecks'
}

{ #category : #accessing }
CardDeckRepository >> garageDoorRemote [
	<gtExample>
	^ CardDeck new
		set: #storageClassName to: 'CardDeckRepository';
		set: #name to: 'Garage Door Remote';
		set: #description
			to: '(State machine example from EI Computational Thinking lecture.)
';
		set: #storageMethodName to: 'garageDoorRemote';
		addCard:
			(Card new
				set: #name to: 'Garage Door';
				set: #description
					to:
					'A garage door can be in one of the following states:

Open
Closed
Opening
Closing
Stopped (while opening)
Stopped (while closing).

The door changes state when it receives a signal from the remote, or from a sensor.';
				yourself);
		yourself
]
