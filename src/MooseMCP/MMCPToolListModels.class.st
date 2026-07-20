Class {
	#name : 'MMCPToolListModels',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

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

{ #category : 'private - execution' }
MMCPToolListModels >> commandForRequest: aRequest [

	^ MMCPListModelsCommand tool: self request: aRequest
]

{ #category : 'metadata' }
MMCPToolListModels >> description [

	^ 'List Moose models currently loaded in the image, with basic entity-count stats.'
]

{ #category : 'executing' }
MMCPToolListModels >> executeWithRequest: aRequest [

	^ self
		  executeParsedRequestFrom: aRequest
		  do: [ :parsedRequest |
				  | result |
				  result := (self commandForRequest: parsedRequest) execute.
				  self
					  successResultText: result size asString , ' model(s) found.'
					  data: result ]
		  onError: [ :error :parsedRequest | self errorResultFor: error ]
]

{ #category : 'metadata' }
MMCPToolListModels >> title [

	^ 'List Models'
]
