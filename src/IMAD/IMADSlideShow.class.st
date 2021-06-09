"
Just a placeholder for the moment.

```
IMADSlideShow new openInSpace
```


"
Class {
	#name : #IMADSlideShow,
	#superclass : #GtSlideShowStencil,
	#category : #'IMAD-Presenter'
}

{ #category : #accessing }
IMADSlideShow >> create [
	| show |
	show := GtSlideShow new.
	show addSlide: (GtTitleSlide new titleText: (self title: 'IMAD')).
	show
		addSlide:
			(GtTextSlide new
				newTextWithFormat: (self heading: 'Placeholder');
				newText: 'I am just a placeholder for now.').
	^ show
]
