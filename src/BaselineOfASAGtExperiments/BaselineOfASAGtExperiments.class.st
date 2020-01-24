Class {
	#name : #BaselineOfASAGtExperiments,
	#superclass : #BaselineOf,
	#category : #BaselineOfASAGtExperiments
}

{ #category : #baselines }
BaselineOfASAGtExperiments >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'ASA-GtExperiments' ].

]
