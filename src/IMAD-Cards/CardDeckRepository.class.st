Class {
	#name : #CardDeckRepository,
	#superclass : #Object,
	#category : #'IMAD-Cards'
}

{ #category : #accessing }
CardDeckRepository >> atmModel [
	<gtExample>
	^ CardDeck new
		set: #storageClassName to: 'CardDeckRepository';
		set: #name to: 'ATM domain';
		set: #description
			to: 'I describe the domain of automated teller machines.';
		set: #storageMethodName to: 'atmModel';
		addCard:
			(Card new
				set: #name to: 'Account';
				set: #description
					to: 'I am an account for a customer. I have a balance.
';
				yourself);
		addCard:
			(Card new
				set: #name to: 'Bank';
				set: #description to: 'I am a bank offering ATM services.';
				yourself);
		addCard:
			(Card new
				set: #name to: 'Customer';
				set: #description
					to: 'I am a customer of a bank with an account.
';
				set: 'customerName' to: '...';
				yourself);
		addRelation: 'account'
			fromCardNamed: 'Customer'
			toCardNamed: 'Account';
		yourself
]

{ #category : #accessing }
CardDeckRepository >> generateTestCardDeck [
	<gtExample>
	^ CardDeck new
		set: #storageClassName to: 'CardDeckRepository';
		set: #name to: 'TestDeck';
		set: #description to: 'For testing purposes';
		set: #storageMethodName to: 'generateTestCardDeck';
		addCard:
			(Card new
				set: #name to: 'A';
				set: #description to: 'To do';
				yourself);
		addCard:
			(Card new
				set: #name to: 'B';
				set: #description to: 'To do';
				yourself);
		addCard:
			(Card new
				set: #name to: 'C';
				set: #description to: 'To do';
				yourself);
		addRelation: 'x' fromCardNamed: 'A' toCardNamed: 'B';
		addRelation: 'x' fromCardNamed: 'A' toCardNamed: 'C';
		addRelation: 'y' fromCardNamed: 'B' toCardNamed: 'C';
		addRelation: 'z' fromCardNamed: 'C' toCardNamed: 'B';
		yourself
]

{ #category : #accessing }
CardDeckRepository >> webShopping [
	<gtExample>
	^ CardDeck new
		set: #storageClassName to: 'CardDeckRepository';
		set: #name to: 'Web Shopping';
		set: #description to: 'I model the process of shopping online.';
		set: #storageMethodName to: 'webShopping';
		addCard:
			(Card new
				set: #name to: 'Cart';
				set: #description
					to: 'I am a shopping cart for online purchasing.';
				yourself);
		addCard:
			(Card new
				set: #name to: 'Customer';
				set: #description
					to: 'I am an online customer of a web shopping site.';
				yourself);
		addCard:
			(Card new
				set: #name to: 'ShoppingSite';
				set: #description
					to: 'I am a web site of a company selling wares online.';
				yourself);
		addRelation: 'cart' fromCardNamed: 'Customer' toCardNamed: 'Cart';
		yourself
]
