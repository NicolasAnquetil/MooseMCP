"
Command that computes metrics for get_metrics by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetMetricsCommand',
	#superclass : 'MCPToolRequestCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPGetMetricsCommand >> execute [

	| modelId entityId metrics groupBy |
	modelId := self request stringArgumentNamed: 'modelId'.
	entityId := self request stringArgumentNamed: 'entityId'.
	metrics := self request
		           stringCollectionArgumentNamed: 'metrics'
		           default: #(  ).
	groupBy := self request
		           stringArgumentNamed: 'groupBy'
		           default: 'none'.
	^ MMCPToolServer default
		  getMetrics: modelId
		  entityId: entityId
		  metrics: metrics
		  groupBy: groupBy
]
