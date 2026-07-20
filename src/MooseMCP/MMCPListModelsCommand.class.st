"
Command that lists loaded Moose models for list_models by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPListModelsCommand',
	#superclass : 'MCPToolRequestCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPListModelsCommand >> execute [

	| includeStats |
	includeStats := self request
		                booleanArgumentNamed: 'includeStats'
		                default: true.
	^ MMCPToolServer default listModels: includeStats
]
