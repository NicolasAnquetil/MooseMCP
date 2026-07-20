Class {
	#name : 'MMCPToolGetRelationships',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'defaults' }
MMCPToolGetRelationships class >> toolName [

	^ 'get_relationships'
]

{ #category : 'metadata' }
MMCPToolGetRelationships >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self modelIdSchemaPropertyDescribed:
					   'The model containing the entity.').
				  (self entityIdSchemaPropertyDescribed:
					   'The entity to get relationships for.').
				  (self
					   stringEnumArraySchemaNamed: 'types'
					   description: 'Relationship types to include.'
					   itemDescription: 'A relationship type.'
					   values:
					   #( 'inheritance' 'invocation' 'reference' 'access' 'association' )).
				  (self
					   stringEnumSchemaPropertyNamed: 'direction'
					   description: 'Which direction of relationship to include.'
					   values: #( 'incoming' 'outgoing' 'both' )
					   default: 'both').
				  (self
					   integerSchemaPropertyNamed: 'depth'
					   description: 'Transitive closure depth (1 = direct only).'
					   default: 1).
				  (self
					   integerSchemaPropertyNamed: 'limit'
					   description: 'Maximum number of edges to return.'
					   default: 50) }
		  required: #( 'modelId' 'entityId' )
]

{ #category : 'private - execution' }
MMCPToolGetRelationships >> commandForRequest: aRequest [

	^ MMCPGetRelationshipsCommand tool: self request: aRequest
]

{ #category : 'metadata' }
MMCPToolGetRelationships >> description [

	^ 'Get relationships (inheritance, calls, references, accesses) for an entity in a Moose model.'
]

{ #category : 'executing' }
MMCPToolGetRelationships >> executeWithRequest: aRequest [

	^ self
		  executeParsedRequestFrom: aRequest
		  do: [ :parsedRequest |
				  | result |
				  result := (self commandForRequest: parsedRequest) execute.
				  self
					  successResultText:
					  (result at: 'edges') size asString
					  , ' relationship edge(s) found.'
					  data: result ]
		  onError: [ :error :parsedRequest | self errorResultFor: error ]
]

{ #category : 'metadata' }
MMCPToolGetRelationships >> title [

	^ 'Get Relationships'
]
