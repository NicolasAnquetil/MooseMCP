"
Command that follows a relationship from every entity in a set for traverse.
"
Class {
	#name : 'MMCPTraverseCommand',
	#superclass : 'MMCPEntitySetCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPTraverseCommand >> execute [

	| setId relationshipName depth entities visited frontier nextFrontier |
	setId := self request stringArgumentNamed: 'setId'.
	relationshipName := self request stringArgumentNamed: 'relationship'.
	depth := self request
		         nonNegativeIntegerArgumentNamed: 'depth'
		         default: 1.
	entities := self entitiesForSetId: setId.
	visited := Set new.
	frontier := entities asOrderedCollection.
	1 to: depth do: [ :level |
			nextFrontier := OrderedCollection new.
			frontier do: [ :e |
					(self traverseRelationship: relationshipName from: e) do: [
							:related |
							(visited includes: related) ifFalse: [
									visited add: related.
									nextFrontier add: related ] ] ].
			frontier := nextFrontier ].
	^ self registerAndDescribe: visited
]
