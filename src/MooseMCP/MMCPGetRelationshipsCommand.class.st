"
Command that resolves relationship edges for get_relationships by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetRelationshipsCommand',
	#superclass : 'MMCPModelEntityCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'relationships' }
MMCPGetRelationshipsCommand >> edgeType: aType from: source to: target direction: aDirection [

	| dict |
	dict := Dictionary new.
	dict at: 'type' put: aType.
	dict at: 'sourceId' put: (source ifNil: [ nil ] ifNotNil: [ :s | s mooseID asString ]).
	dict at: 'targetId' put: (target ifNil: [ nil ] ifNotNil: [ :t | t mooseID asString ]).
	dict at: 'direction' put: aDirection asString.
	^ dict

]

{ #category : 'accessing' }
MMCPGetRelationshipsCommand >> executeOn: model entity: entity [

	| types direction depth limit root edges visited frontier nextFrontier effectiveTypes dir |
	entity ifNil: [ ^ Error signal: 'entityId is required for get_relationships' ].
	root := entity.
	types := self request
		         stringCollectionArgumentNamed: 'types'
		         default: #( 'inheritance' 'invocation' ).
	direction := self request
		             stringArgumentNamed: 'direction'
		             default: 'outgoing'.
	depth := self request
		         nonNegativeIntegerArgumentNamed: 'depth'
		         default: 1.
	limit := self request
		         nonNegativeIntegerArgumentNamed: 'limit'
		         default: 50.
	effectiveTypes := (types isNil or: [ types isEmpty ])
		                  ifTrue: [ #( 'inheritance' 'invocation' ) ]
		                  ifFalse: [ types ].
	self checkRelationshipTypes: effectiveTypes in: model.
	dir := direction ifNil: [ 'outgoing' ].
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

{ #category : 'relationships' }
MMCPGetRelationshipsCommand >> relatedTo: anEntity type: aType0 direction: aDirection [

	| aType |
	aType := aType0 asLowercase.

	aType = 'inheritance' ifTrue: [
			^ aDirection = #outgoing
				  ifTrue: [
						  (self safePerform: #superInheritances on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | self safeCollect: c selector: #superclass ] ]
				  ifFalse: [
						  (self safePerform: #subInheritances on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | self safeCollect: c selector: #subclass ] ] ].
	aType = 'invocation' ifTrue: [
			^ aDirection = #outgoing
				  ifTrue: [
				  (self safePerform: #invokedMethods on: anEntity) ifNil: [ #(  ) ] ]
				  ifFalse: [
				  (self safePerform: #invokingMethods on: anEntity) ifNil: [
					  #(  ) ] ] ].
	aType = 'access' ifTrue: [
			^ aDirection = #outgoing
				  ifTrue: [
						  (self safePerform: #accesses on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | self safeCollect: c selector: #variable ] ]
				  ifFalse: [
						  (self safePerform: #incomingAccesses on: anEntity)
							  ifNil: [ #(  ) ]
							  ifNotNil: [ :c | self safeCollect: c selector: #accessor ] ] ].
	^ (aDirection = #outgoing
		  ifTrue: [
		  (self safePerform: #allProviders on: anEntity) ifNil: [ #(  ) ] ]
		  ifFalse: [
		  (self safePerform: #allClients on: anEntity) ifNil: [ #(  ) ] ]) reject: [ :e | e isNil ]
]

{ #category : 'private' }
MMCPGetRelationshipsCommand >> safeCollect: aCollection selector: aSelector [

	^ (aCollection collect: [ :each | [ each perform: aSelector ] on: Error do: [ :ex | nil ] ]) reject: [ :e | e isNil ]
]
