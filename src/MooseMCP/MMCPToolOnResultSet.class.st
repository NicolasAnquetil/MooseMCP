Class {
	#name : 'MMCPToolOnResultSet',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'testing' }
MMCPToolOnResultSet class >> isAbstract [

	^ self = MMCPToolOnResultSet 
]

{ #category : 'private - schema' }
MMCPToolOnResultSet >> setIdSchemaPropertyDescribed: aDescription [

	^ self
		  schemaPropertyNamed: 'setId'
		  type: 'string'
		  description: aDescription
]
