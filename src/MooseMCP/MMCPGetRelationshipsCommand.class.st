"
Command that resolves relationship edges for get_relationships by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetRelationshipsCommand',
	#superclass : 'MCPToolRequestCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPGetRelationshipsCommand >> execute [

	| modelId entityId types direction depth limit |
	modelId := self request stringArgumentNamed: 'modelId'.
	entityId := self request stringArgumentNamed: 'entityId'.
	types := self request
		         stringCollectionArgumentNamed: 'types'
		         default: #( 'inheritance' 'invocation' ).
	direction := self request
		             stringArgumentNamed: 'direction'
		             default: 'both'.
	depth := self request
		         nonNegativeIntegerArgumentNamed: 'depth'
		         default: 1.
	limit := self request
		         nonNegativeIntegerArgumentNamed: 'limit'
		         default: 50.
	^ MMCPToolServer default
		  getRelationships: modelId
		  entityId: entityId
		  types: types
		  direction: direction
		  depth: depth
		  limit: limit
]
