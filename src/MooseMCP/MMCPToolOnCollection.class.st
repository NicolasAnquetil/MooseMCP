Class {
	#name : 'MMCPToolOnCollection',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'testing' }
MMCPToolOnCollection class >> isAbstract [

	^ self = MMCPToolOnCollection 
]

{ #category : 'private - schema' }
MMCPToolOnCollection >> setIdSchemaPropertyDescribed: aDescription [

	^ self
		  schemaPropertyNamed: 'setId'
		  type: 'string'
		  description: aDescription
]
