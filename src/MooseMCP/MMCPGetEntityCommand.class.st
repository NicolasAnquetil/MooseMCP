"
Command that resolves entities for get_entity by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetEntityCommand',
	#superclass : 'MCPToolRequestCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPGetEntityCommand >> execute [

	| modelId query entityId entityType exactMatch limit |
	modelId := self request stringArgumentNamed: 'modelId'.
	query := self request stringArgumentNamed: 'query' default: ''.
	entityId := self request stringArgumentNamed: 'entityId'.
	entityType := self request stringArgumentNamed: 'entityType'.
	exactMatch := self request
		              booleanArgumentNamed: 'exactMatch'
		              default: false.
	limit := self request
		         nonNegativeIntegerArgumentNamed: 'limit'
		         default: 20.
	^ MMCPToolServer default
		  getEntity: modelId
		  query: query
		  entityId: entityId
		  entityType: entityType
		  exactMatch: exactMatch
		  limit: limit
]
