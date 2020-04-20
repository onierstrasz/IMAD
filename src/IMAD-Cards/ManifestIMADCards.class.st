"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestIMADCards,
	#superclass : #PackageManifest,
	#category : #'IMAD-Cards-Manifest'
}

{ #category : #'code-critics' }
ManifestIMADCards class >> ruleRBClassNotReferencedRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#FacultyDoodleModelingExamples)) #'2020-04-20T17:13:22.519368+02:00') #(#(#RGClassDefinition #(#CardDeckTestExamples)) #'2020-04-20T17:13:32.795256+02:00') )
]
