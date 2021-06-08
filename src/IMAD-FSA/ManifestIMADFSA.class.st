"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser

"
Class {
	#name : #ManifestIMADFSA,
	#superclass : #PackageManifest,
	#category : #'IMAD-FSA-Manifest'
}

{ #category : #'code-critics' }
ManifestIMADFSA class >> ruleRBCollectionProtocolRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#FSAViewController #setFSAstateColors #false)) #'2020-04-28T16:20:30.721999+02:00') )
]
