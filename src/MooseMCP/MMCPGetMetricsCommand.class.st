"
Command that computes metrics for get_metrics by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetMetricsCommand',
	#superclass : 'MMCPModelEntityCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'accessing' }
MMCPGetMetricsCommand >> executeOn: model entity: entity [

	| metrics groupBy names targets |
	metrics := self request
		           stringCollectionArgumentNamed: 'metrics'
		           default: #(  ).
	groupBy := self request
		           stringArgumentNamed: 'groupBy'
		           default: 'none'.
	names := (metrics isNil or: [ metrics isEmpty ])
		         ifTrue: [
		         self metricSelectors keys asSortedCollection
			         asOrderedCollection ]
		         ifFalse: [ metrics ].
	self checkMetrics: names in: model.
	targets := entity
		           ifNil: [ self groupTargetsFor: model groupBy: groupBy ]
		           ifNotNil: [ OrderedCollection with: entity ].
	^ (targets collect: [ :each |
			   | row metricsDict eId |
			   metricsDict := Dictionary new.
			   names do: [ :m |
				   metricsDict at: m put: (self computeMetric: m for: each) ].
			   row := Dictionary new.
			   eId := self safePerform: #mooseID on: each.
			   row at: 'entityId' put: (eId ifNotNil: [ eId asString ]).
			   row at: 'metrics' put: metricsDict.
			   row ]) asArray
]
