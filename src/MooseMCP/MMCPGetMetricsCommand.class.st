"
Command that computes metrics for get_metrics by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetMetricsCommand',
	#superclass : 'MMCPCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPGetMetricsCommand >> execute [

	| modelId entityId metrics groupBy model names targets |
	modelId := self request stringArgumentNamed: 'modelId'.
	entityId := self request stringArgumentNamed: 'entityId'.
	metrics := self request
		           stringCollectionArgumentNamed: 'metrics'
		           default: #(  ).
	groupBy := self request
		           stringArgumentNamed: 'groupBy'
		           default: 'none'.
	model := self modelNamed: modelId.
	names := (metrics isNil or: [ metrics isEmpty ])
		         ifTrue: [
		         self metricSelectors keys asSortedCollection
			         asOrderedCollection ]
		         ifFalse: [ metrics ].
	targets := (entityId isNil or: [ entityId isEmpty ])
		           ifTrue: [ self groupTargetsFor: model groupBy: groupBy ]
		           ifFalse: [
		           OrderedCollection with:
			           (self entityWithId: entityId in: model) ].
	^ (targets collect: [ :entity |
			   | row metricsDict eId |
			   metricsDict := Dictionary new.
			   names do: [ :m |
				   metricsDict at: m put: (self computeMetric: m for: entity) ].
			   row := Dictionary new.
			   eId := self safePerform: #mooseID on: entity.
			   row at: 'entityId' put: (eId ifNotNil: [ eId asString ]).
			   row at: 'metrics' put: metricsDict.
			   row ]) asArray
]
