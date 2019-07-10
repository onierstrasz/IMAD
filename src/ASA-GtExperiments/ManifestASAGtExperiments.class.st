"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestASAGtExperiments,
	#superclass : #PackageManifest,
	#category : #'ASA-GtExperiments-Manifest'
}

{ #category : #'code-critics' }
ManifestASAGtExperiments class >> ruleGRTemporaryNeitherReadNorWrittenRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#GtModelingExamples #graphWithDirectedEdges #false)) #'2019-07-10T13:29:55.052078+02:00') )
]
