Class {
	#name : 'MMCPToolGetEntity',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolGetEntity class >> commandClass [

	^ MMCPGetEntityCommand
]

{ #category : 'defaults' }
MMCPToolGetEntity class >> toolName [

	^ 'get_entity'
]

{ #category : 'metadata' }
MMCPToolGetEntity >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self modelIdSchemaPropertyDescribed: 'The model to search in.').
				  (self
					   schemaPropertyNamed: 'query'
					   type: 'string'
					   description:
					   'Qualified name, simple name, or substring pattern.').
				  (self entityIdSchemaPropertyDescribed:
					   'Exact Moose entity id; if given, query is ignored.').
				  (self
					   stringEnumSchemaPropertyNamed: 'entityType'
					   description: 'Filter by kind.'
					   values: #( 'package' 'class' 'method' 'attribute' 'variable' )).
				  (self
					   booleanSchemaPropertyNamed: 'exactMatch'
					   description:
					   'Whether to require an exact name match instead of a substring match.'
					   default: false).
				  (self
					   integerSchemaPropertyNamed: 'limit'
					   description: 'Maximum number of entities to return.'
					   default: 20) }
		  required: #( 'modelId' )
]

{ #category : 'metadata' }
MMCPToolGetEntity >> description [

	^ 'Look up entities in a Moose model by name pattern or id, returning their properties.'
]

{ #category : 'private - results' }
MMCPToolGetEntity >> successSummaryForResult: result request: aRequest [

	^ result size asString , ' entity(ies) found.'
]

{ #category : 'metadata' }
MMCPToolGetEntity >> title [

	^ 'Get Entity'
]
