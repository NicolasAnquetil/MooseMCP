"
Command that resolves entities for get_entity by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetEntityCommand',
	#superclass : 'MMCPCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPGetEntityCommand >> execute [

	| modelId query entityId entityType exactMatch limit model candidates matches |
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
	model := self modelNamed: modelId.
	(entityId isNil or: [ entityId isEmpty ]) ifFalse: [
			^ Array with:
				  (self describeEntity: (self entityWithId: entityId in: model)) ].
	candidates := (entityType isNil or: [ entityType isEmpty ])
		              ifTrue: [ model entityStorage ]
		              ifFalse: [ self entitiesOfType: entityType in: model ].
	matches := (candidates select: [ :e |
			            | name |
			            name := (self safePerform: #mooseName on: e) ifNil: [
				                    '' ].
			            exactMatch
				            ifTrue: [ name = query ]
				            ifFalse: [
				            name asLowercase includesSubstring: query asLowercase ] ])
		           asOrderedCollection.
	^ ((matches first: (matches size min: limit)) collect: [ :e |
		   self describeEntity: e ]) asArray
]
