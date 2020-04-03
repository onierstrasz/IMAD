Class {
	#name : #IMADutilities,
	#superclass : #Object,
	#category : #'IMAD-Cards-Utilities'
}

{ #category : #accessing }
IMADutilities class >> examplesExplorerFromBaselineClass: baseline andRepoDescription: githubRepo [
	| projectBuilder project |
	projectBuilder := GtRlDependenciesModelBuilder new.
	project := projectBuilder 
		buildProjectFromBaselineClass: baseline
		withRepositoryDescription: githubRepo.
	^ GtRlSystemExamplesExplorer forProject: project
]

{ #category : #accessing }
IMADutilities class >> myExamplesExplorer [
	"IMADutilities myExamplesExplorer"
	^ self examplesExplorerFromBaselineClass: BaselineOfIMAD  andRepoDescription: 'github.com/onierstrasz/ASA-GtExperiments/src'
]
