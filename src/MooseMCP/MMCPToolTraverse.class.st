Class {
	#name : 'MMCPToolTraverse',
	#superclass : 'MMCPToolOnResultSet',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolTraverse class >> commandClass [

	^ MMCPTraverseCommand
]

{ #category : 'defaults' }
MMCPToolTraverse class >> toolName [

	^ 'traverse'
]

{ #category : 'metadata' }
MMCPToolTraverse >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self setIdSchemaPropertyDescribed: 'The entity set to traverse from.').
				  (self
					   stringEnumSchemaPropertyNamed: 'relationship'
					   description: 'Relationship to follow from each entity in the set.'
					   values:
						   #( 'methods' 'attributes' 'package' 'definingClass'
						      'superclass' 'subclasses' 'invokedMethods'
						      'invokingMethods' 'accesses' 'accessingMethods' )).
				  (self
					   integerSchemaPropertyNamed: 'depth'
					   description: '1 = direct only; >1 follows transitively.'
					   default: 1) }
		  required: #( 'setId' 'relationship' )
]

{ #category : 'metadata' }
MMCPToolTraverse >> description [

	^ 'Follow a relationship from every entity in a set to produce a new set of related entities.'
]

{ #category : 'private - results' }
MMCPToolTraverse >> successSummaryForResult: result request: aRequest [

	^ (result at: 'count') asString , ' entities in new set '
	  , (result at: 'setId') , '.'
]

{ #category : 'metadata' }
MMCPToolTraverse >> title [

	^ 'Traverse'
]
