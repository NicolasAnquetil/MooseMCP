"
Command that resolves relationship edges for get_relationships by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetRelationshipsCommand',
	#superclass : 'MMCPCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPGetRelationshipsCommand >> execute [

	| modelId entityId types direction depth limit model root edges visited frontier nextFrontier effectiveTypes dir |
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
	model := self modelNamed: modelId.
	root := self entityWithId: entityId in: model.
	effectiveTypes := (types isNil or: [ types isEmpty ])
		                  ifTrue: [ #( 'inheritance' 'invocation' ) ]
		                  ifFalse: [ types ].
	dir := direction ifNil: [ 'both' ].
	edges := OrderedCollection new.
	visited := Set new.
	visited add: root.
	frontier := OrderedCollection with: root.
	1 to: depth do: [ :level |
			nextFrontier := OrderedCollection new.
			frontier do: [ :e |
					effectiveTypes do: [ :aType |
							(dir = 'outgoing' or: [ dir = 'both' ]) ifTrue: [
									(self relatedTo: e type: aType direction: #outgoing) do: [
											:target |
											edges add: (self
													 edgeType: aType
													 from: e
													 to: target
													 direction: #outgoing).
											(visited includes: target) ifFalse: [
													visited add: target.
													nextFrontier add: target ] ] ].
							(dir = 'incoming' or: [ dir = 'both' ]) ifTrue: [
									(self relatedTo: e type: aType direction: #incoming) do: [
											:source |
											edges add: (self
													 edgeType: aType
													 from: source
													 to: e
													 direction: #incoming).
											(visited includes: source) ifFalse: [
													visited add: source.
													nextFrontier add: source ] ] ] ] ].
			frontier := nextFrontier ].
	^ Dictionary new
		  at: 'edges' put: (edges first: (edges size min: limit)) asArray;
		  at: 'truncated' put: edges size > limit;
		  yourself
]
