"
I am the abstract base for MooseMCP tools.

I factor out the input-schema boilerplate shared by list_models, get_entity, get_relationships, get_metrics, and render_visualization: the object/properties/required/additionalProperties wrapper, and the modelId/entityId property shape that most of them share.
"
Class {
	#name : 'MMCPTool',
	#superclass : 'MCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPTool class >> commandClass [

	self subclassResponsibility
]

{ #category : 'metadata' }
MMCPTool class >> groupName [

	^ 'moose'
]

{ #category : 'testing' }
MMCPTool class >> isAbstract [

	^ self = MMCPTool
]

{ #category : 'testing' }
MMCPTool class >> isBuiltIn [

	^ self package = MMCPTool package
]

{ #category : 'metadata' }
MMCPTool class >> toolMutability [

	^ #read
]

{ #category : 'metadata' }
MMCPTool >> buildOutputSchema [

	^nil
]

{ #category : 'private - execution' }
MMCPTool >> commandForRequest: aRequest [

	^ self class commandClass tool: self request: aRequest
]

{ #category : 'defaults' }
MMCPTool >> defaultOutputSchema [

	^ nil
]

{ #category : 'executing' }
MMCPTool >> executeWithRequest: aRequest [

	^ self
		  executeParsedRequestFrom: aRequest
		  do: [ :parsedRequest |
				  | result |
				  result := (self commandForRequest: parsedRequest) execute.
				  self
					  successResultText: (self successSummaryForResult: result request: parsedRequest)
					  data: result ]
		  onError: [ :error :parsedRequest | self errorResultFor: error ]
]

{ #category : 'private - schema' }
MMCPTool >> filterSpecSchema [

	^ MCPStructureProperties new
		  type: 'object';
		  description: 'One property filter.';
		  properties: {
				  (self
					   schemaPropertyNamed: 'property'
					   type: 'string'
					   description:
						   'Property name, e.g. name, isAbstract, numberOfLinesOfCode.').
				  (self
					   stringEnumSchemaPropertyNamed: 'operator'
					   description: 'Comparison operator.'
					   values:
						   #( 'equals' 'notEquals' 'contains' 'matches' 'gt' 'gte' 'lt'
						      'lte' 'in' )).
				  (self
					   schemaPropertyNamed: 'value'
					   type: nil
					   description: 'Value to compare against.') };
		  required: #( 'property' 'operator' 'value' );
		  additionalProperties: false;
		  yourself
]

{ #category : 'private - schema' }
MMCPTool >> filtersSchemaProperty [

	^ (self
		   schemaPropertyNamed: 'filters'
		   type: 'array'
		   description: 'Property filters to apply.')
		  items: self filterSpecSchema;
		  yourself
]

{ #category : 'private - schema' }
MMCPTool >> objectInputSchemaWithProperties: propertiesArray required: requiredArray [

	^ MCPStructureInputSchema new
		  type: 'object';
		  properties: propertiesArray;
		  required: requiredArray;
		  additionalProperties: false;
		  yourself
]

{ #category : 'private - results' }
MMCPTool >> successSummaryForResult: result request: aRequest [

	self subclassResponsibility
]
