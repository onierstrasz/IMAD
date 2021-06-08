"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser

"
Class {
	#name : #ManifestIMADCards,
	#superclass : #PackageManifest,
	#category : #'IMAD-Cards-Manifest'
}

{ #category : #'code-critics' }
ManifestIMADCards class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#Card #assertInvariant #false)) #'2020-05-02T08:47:09.495671+02:00') #(#(#RGMethodDefinition #(#CardRelation #assertInvariant #false)) #'2020-05-05T13:32:13.182526+02:00') )
]

{ #category : #'code-critics' }
ManifestIMADCards class >> ruleRBClassNotReferencedRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#CardDeckExamples)) #'2020-04-20T17:13:22.519368+02:00') #(#(#RGClassDefinition #(#CardDeckTestExamples)) #'2020-04-20T17:13:32.795256+02:00') )
]

{ #category : #'code-critics' }
ManifestIMADCards class >> ruleRBCodeCruftLeftInMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#UsefulExamples #buttonWithActions #false)) #'2020-04-21T17:04:06.500042+02:00') )
]
