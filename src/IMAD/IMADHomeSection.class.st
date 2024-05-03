Class {
	#name : #IMADHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'IMAD-Sections'
}

{ #category : #initialization }
IMADHomeSection >> defaultPriority [
	^ 5
]

{ #category : #initialization }
IMADHomeSection >> sectionTitle [
	^ 'IMAD'
]

{ #category : #accessing }
IMADHomeSection >> tocCard [
	<gtSectionCard>
	<gtExample>
	^ GtHomeCard page
		title: 'IMAD ToC';
		description: 'IMAD Lepiter database';
		priority: 10;
		pageName: 'IMAD ToC';
		databaseName: 'onierstrasz/IMAD/lepiter';
		assertInvariant;
		yourself
]
