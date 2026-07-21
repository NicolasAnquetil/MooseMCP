Class {
	#name : 'MMCPToolOnModel',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'testing' }
MMCPToolOnModel class >> isAbstract [

	^ self = MMCPToolOnModel 
]

{ #category : 'private - schema' }
MMCPToolOnModel >> entityIdSchemaPropertyDescribed: aDescription [

	^ self
		  schemaPropertyNamed: 'entityId'
		  type: 'string'
		  description: aDescription
]

{ #category : 'private - schema' }
MMCPToolOnModel >> modelIdSchemaPropertyDescribed: aDescription [

	^ self
		  schemaPropertyNamed: 'modelId'
		  type: 'string'
		  description: aDescription
]
