Class {
	#name : #CardDeckRepository,
	#superclass : #Object,
	#category : #'IMAD-Cards-CardDecks'
}

{ #category : #accessing }
CardDeckRepository >> garageDoorRemote [
	<gtExample>
	^ CardDeck new
		name: 'Garage Door Remote';
		description:
			'(State machine example from EI Computational Thinking lecture.)

Entities are:
- A Garage Door
- A remote control
- A car
- A Sensor

A garage door can be in one of the following states:

Open
Closed
Opening
Closing
Stopped (while opening)
Stopped (while closing).

The door changes state when it receives a signal from the remote, or from a sensor.

In this example we can describe the m2 entities, and a concrete m1 scenario.
';
		set: #storageClassName to: 'CardDeckRepository';
		set: #storageMethodName to: 'garageDoorRemote';
		addCard:
			(Card new
				name: 'Garage Door';
				description:
					'A garage door can be in one of the following states:

Open
Closed
Opening
Closing
Stopped (while opening)
Stopped (while closing).

The door changes state when it receives a signal from the remote, or from a sensor.
';
				yourself);
		addCard:
			(Card new
				name: 'Homer''s Garage Door';
				description: 'To do';
				yourself);
		addCard:
			(Card new
				name: 'Homer''s Remote';
				description: 'To do';
				yourself);
		addCard:
			(Card new
				name: 'Remote Control';
				description:
					'The remote has a single button. Pressing it causes the door to change state, i.e., from closed to opening, etc.';
				yourself);
		addRelation: 'instanceOf'
			fromCardNamed: 'Homer''s Garage Door'
			toCardNamed: 'Garage Door';
		addRelation: 'instanceOf'
			fromCardNamed: 'Homer''s Remote'
			toCardNamed: 'Remote Control';
		addRelation: 'controls'
			fromCardNamed: 'Remote Control'
			toCardNamed: 'Garage Door';
		yourself
]
