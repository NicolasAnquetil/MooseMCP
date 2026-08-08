Class {
	#name : 'MMCPToolGetRelationships',
	#superclass : 'MMCPToolOnModel',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolGetRelationships class >> commandClass [

	^ MMCPGetRelationshipsCommand
]

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
				  self relationshipTypesSchemaProperty.
				  (self
					   stringEnumSchemaPropertyNamed: 'direction'
					   description: 'Which direction of relationship to include.'
					   values: #( 'incoming' 'outgoing' 'both' )
					   default: 'outgoing').
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

{ #category : 'metadata' }
MMCPToolGetRelationships >> description [

	^ 'Get relationships (inheritance, calls, references, accesses) for an entity in a Moose model.'
]

{ #category : 'private - schema' }
MMCPToolGetRelationships >> relationshipTypesSchemaProperty [

	| itemsProperty |
	itemsProperty := MCPStructureProperties new
		                 type: 'string';
		                 description:
			                 'A Famix association type for this model (e.g. Inheritance, Invocation, Access, Reference; case-insensitive). Valid names depend on the model''s metamodel.';
		                 yourself.
	^ (self
		   schemaPropertyNamed: 'types'
		   type: 'array'
		   description:
			   'Relationship types to include; omit for a sensible default set.')
		  items: itemsProperty;
		  yourself
]

{ #category : 'private - results' }
MMCPToolGetRelationships >> successSummaryForResult: result request: aRequest [

	^ (result at: 'edges') size asString , ' relationship edge(s) found.'
]

{ #category : 'metadata' }
MMCPToolGetRelationships >> title [

	^ 'Get Relationships'
]
