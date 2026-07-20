Class {
	#name : 'MMCPToolListModels',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolListModels class >> commandClass [

	^ MMCPListModelsCommand
]

{ #category : 'defaults' }
MMCPToolListModels class >> toolName [

	^ 'list_models'
]

{ #category : 'metadata' }
MMCPToolListModels >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: { (self
				   booleanSchemaPropertyNamed: 'includeStats'
				   description:
				   'Include entity counts (packages/classes/methods) per model.'
				   default: true) }
		  required: #(  )
]

{ #category : 'metadata' }
MMCPToolListModels >> description [

	^ 'List Moose models currently loaded in the image, with basic entity-count stats.'
]

{ #category : 'private - results' }
MMCPToolListModels >> successSummaryForResult: result request: aRequest [

	^ result size asString , ' model(s) found.'
]

{ #category : 'metadata' }
MMCPToolListModels >> title [

	^ 'List Models'
]
