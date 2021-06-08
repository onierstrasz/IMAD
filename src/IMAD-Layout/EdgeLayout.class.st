"
I am a place to experiment with edge layout algorithms that will eventually move back to GT.

"
Class {
	#name : #EdgeLayout,
	#superclass : #Object,
	#category : #'IMAD-Layout'
}

{ #category : #accessing }
EdgeLayout >> brokenLayoutDemo [
<gtExample>

"This snippet illustrates the issue. From/to nearest bounds (using BlNearestPositionBoundsAnchor) nicely connects edges to the boundaries of nodes, but the connection anchors are ugly. From/to nearest tight circle (using BlNearestPositionTightCircleAnchor) nicely aligns the edges along the paths between the centers of the connected nodes, but does not put the edges anchors on the boundaries of the nodes."
| makeArrow view |
makeArrow := [ :x | 
	BlLineElement new
		border: (BlBorder paint: Color gray);
		toHead: (BlArrowheadSimpleArrow new
				border: (BlBorder builder paint: Color gray; build))].

view := GtMondrian new.
view nodes
	shape: [ :x |
		BlTextElement new
			text: (x asRopedText );
			border: (BlBorder paint: Color gray);
			padding: (BlInsets all: 5) ];
	with: { 'Shape' . 'Square' . 'Rectangle' . 'Circle' . 'Ellipse' } .

view edges
	fromNearestBounds;
	toNearestBounds;
	shape: makeArrow;
	connect: { 'Shape' -> 'Square' . 'Square' -> 'Rectangle' }
	from: #key to: #value.


view edges
	fromNearestTightCircle;
	toNearestTightCircle;
	shape: makeArrow;
	connect: { 'Shape' -> 'Circle' . 'Circle' -> 'Ellipse' }
	from: #key to: #value.

view layout tree.
^ view
]

{ #category : #accessing }
EdgeLayout >> fixedLayoutDemo [
	<gtExample>
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :x | 
			BlTextElement new
				text: x asRopedText;
				border: (BlBorder paint: Color gray);
				padding: (BlInsets all: 5) ];
		with: {'Shape' . 'Square' . 'Rectangle' . 'Circle' . 'Ellipse'}.
	view edges
		connect:
			{('Shape' -> 'Square').
			('Square' -> 'Rectangle').
			('Shape' -> 'Circle').
			('Circle' -> 'Ellipse')}
		from: #key
		to: #value.
	view layout tree.
	^ view
]

{ #category : #accessing }
EdgeLayout >> twoNodesFooBar [
	"self root graph edgeChildren first fromAnchor"

	<gtExample>
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :x | 
			BlTextElement new
				text: x asRopedText;
				border: (BlBorder paint: Color gray);
				padding: (BlInsets all: 5) ];
		with: {'Foo' . 'Bar'}.
	view edges
		connect: {('Foo' -> 'Bar')} from: #key to: #value.
	view layout tree.
	^ view
]
