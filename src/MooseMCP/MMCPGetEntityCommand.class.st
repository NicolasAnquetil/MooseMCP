"
Command that resolves entities for get_entity by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPGetEntityCommand',
	#superclass : 'MMCPModelEntityCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'accessing' }
MMCPGetEntityCommand >> executeOn: model entity: entity [

	| query entityType exactMatch limit candidates matches |
	entity ifNotNil: [ ^ Array with: (self describeEntity: entity) ].

	query := self request stringArgumentNamed: 'query' default: ''.
	entityType := self request stringArgumentNamed: 'entityType'.
	exactMatch := self request
		              booleanArgumentNamed: 'exactMatch'
		              default: false.
	limit := self request
		         nonNegativeIntegerArgumentNamed: 'limit'
		         default: 20.
	candidates := (entityType isNil or: [ entityType isEmpty ])
		              ifTrue: [ model entityStorage ]
		              ifFalse: [
				              self checkEntityType: entityType in: model.
				              self entitiesOfType: entityType in: model ].
	matches := (candidates select: [ :e |
			            | name |
			            name := (self safePerform: #mooseName on: e) ifNil: [ '' ].
			            exactMatch
				            ifTrue: [ name = query ]
				            ifFalse: [ name asLowercase includesSubstring: query asLowercase ] ])
		           asOrderedCollection.
	^ ((matches first: (matches size min: limit)) collect: [ :e |
		   self describeEntity: e ]) asArray
]
