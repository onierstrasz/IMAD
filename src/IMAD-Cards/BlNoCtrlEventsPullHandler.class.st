"
I'm a ${class:BlPullHandler}$ that does not listen to CTRL events (so they can be handled by the ${class:EdgeCreationHandler}$ instead).

AS says:

in the future if you see that you have another case when you would like to prevent an existing event handler from handling events based on some condition you can decorate that event handler with an event handler decorator that checks the condition and then forwards the event if condition is met. Something like BlEventForwarder (edited) 


"
Class {
	#name : #BlNoCtrlEventsPullHandler,
	#superclass : #BlPullHandler,
	#category : #'IMAD-Cards-View'
}

{ #category : #accessing }
BlNoCtrlEventsPullHandler >> wantsEvent: anEvent [
	"I ignore Control events"
	^ (super wantsEvent: anEvent) and: [ anEvent modifiers isCtrl not ]
]
