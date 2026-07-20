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

{ #category : 'as yet unclassified' }
MMCPTool class >> toolMutability [

	^ #read
]

{ #category : 'defaults' }
MMCPTool >> defaultOutputSchema [

	^ nil
]

{ #category : 'private - schema' }
MMCPTool >> entityIdSchemaPropertyDescribed: aDescription [

	^ self
		  schemaPropertyNamed: 'entityId'
		  type: 'string'
		  description: aDescription
]

{ #category : 'private - schema' }
MMCPTool >> modelIdSchemaPropertyDescribed: aDescription [

	^ self
		  schemaPropertyNamed: 'modelId'
		  type: 'string'
		  description: aDescription
]

{ #category : 'defaults' }
MMCPTool >> mutability [

	^ 'read'
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

{ #category : 'defaults' }
MMCPTool >> risk [

	^ 'low'
]

{ #category : 'private - schema' }
MMCPTool >> schemaStringPropertyNamed: propertyName description: propertyDescription [

	^ self
		  schemaPropertyNamed: propertyName
		  type: 'string'
		  description: propertyDescription
]
