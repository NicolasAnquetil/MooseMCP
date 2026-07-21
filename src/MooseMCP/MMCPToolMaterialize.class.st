Class {
	#name : 'MMCPToolMaterialize',
	#superclass : 'MMCPToolOnCollection',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'accessing' }
MMCPToolMaterialize class >> commandClass [

	^ MMCPMaterializeCommand
]

{ #category : 'accessing' }
MMCPToolMaterialize class >> toolName [

	^ 'materialize'
]

{ #category : 'schema' }
MMCPToolMaterialize >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self setIdSchemaPropertyDescribed: 'The entity set to page through.').
				  (self
					   integerSchemaPropertyNamed: 'offset'
					   description: 'Pagination offset.'
					   default: 0).
				  (self
					   integerSchemaPropertyNamed: 'limit'
					   description: 'Maximum number of entities to return.'
					   default: 20).
				  (self
					   schemaPropertyNamed: 'fields'
					   type: 'array'
					   description:
					   'Omit for a default summary (name, qualifiedName, type).') }
		  required: #( 'setId' )
]

{ #category : 'metadata' }
MMCPToolMaterialize >> description [

	^ 'Return actual entity details for a set, paginated.'
]

{ #category : 'executing' }
MMCPToolMaterialize >> successSummaryForResult: result request: aRequest [

	^ (result at: 'items') size asString , ' of '
	  , (result at: 'total') asString , ' entities returned.'
]

{ #category : 'metadata' }
MMCPToolMaterialize >> title [

	^ 'Materialize'
]
