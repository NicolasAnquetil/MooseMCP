Class {
	#name : 'MMCPToolQuery',
	#superclass : 'MMCPToolOnModel',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolQuery class >> commandClass [

	^ MMCPQueryCommand
]

{ #category : 'defaults' }
MMCPToolQuery class >> toolName [

	^ 'query'
]

{ #category : 'metadata' }
MMCPToolQuery >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self modelIdSchemaPropertyDescribed: 'The model to search in.').
				  (self
					   stringEnumSchemaPropertyNamed: 'entityType'
					   description: 'Kind of entity to select.'
					   values: #( 'package' 'class' 'method' 'attribute' 'variable' )).
				  self filtersSchemaProperty }
		  required: #( 'modelId' 'entityType' )
]

{ #category : 'metadata' }
MMCPToolQuery >> description [

	^ 'Create a new entity set from a model, optionally filtered.'
]

{ #category : 'private - results' }
MMCPToolQuery >> successSummaryForResult: result request: aRequest [

	^ (result at: 'count') asString , ' entities in new set '
	  , (result at: 'setId') , '.'
]

{ #category : 'metadata' }
MMCPToolQuery >> title [

	^ 'Query'
]
