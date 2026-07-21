Class {
	#name : 'MMCPToolGetRelationshipsTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testAccessRelationshipType [

	| result edge |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> otherMethod mooseID asString).
			          (#types -> #( 'access' )).
			          (#direction -> 'outgoing') } asDictionary.

	self assert: (result at: 'edges') size equals: 1.
	edge := (result at: 'edges') first.
	self assert: (edge at: 'targetId') equals: attribute mooseID asString
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testDefaultTypesReturnInheritanceEdge [

	| result edge |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> subClass mooseID asString) } asDictionary.

	self deny: (result at: 'truncated').
	edge := (result at: 'edges') detect: [ :e |
		        (e at: 'type') = 'inheritance' ].
	self assert: (edge at: 'sourceId') equals: subClass mooseID asString.
	self assert: (edge at: 'targetId') equals: baseClass mooseID asString
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testDepthFollowsTransitively [

	| depth1 depth2 |
	depth1 := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> otherMethod mooseID asString).
			          (#types -> #( 'invocation' )).
			          (#direction -> 'outgoing').
			          (#depth -> 1) } asDictionary.
	depth2 := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> otherMethod mooseID asString).
			          (#types -> #( 'invocation' )).
			          (#direction -> 'outgoing').
			          (#depth -> 2) } asDictionary.

	self assert: (depth1 at: 'edges') size equals: 1.
	self assert: (depth2 at: 'edges') size equals: 2.
	self
		assert: ((depth2 at: 'edges') last at: 'targetId')
		equals: baseMethod mooseID asString
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testDirectionIncomingForInvocation [

	| incoming |
	incoming := self callToolWith: {
			            (#modelId -> self modelName).
			            (#entityId -> baseMethod mooseID asString).
			            (#types -> #( 'invocation' )).
			            (#direction -> 'incoming') } asDictionary.

	self assert: (incoming at: 'edges') size equals: 1.
	self
		assert: ((incoming at: 'edges') first at: 'sourceId')
		equals: subMethod mooseID asString
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testDirectionOutgoingForInvocation [

	| outgoing |
	outgoing := self callToolWith: {
			            (#modelId -> self modelName).
			            (#entityId -> subMethod mooseID asString).
			            (#types -> #( 'invocation' )).
			            (#direction -> 'outgoing') } asDictionary.

	self assert: (outgoing at: 'edges') size equals: 1.
	self
		assert: ((outgoing at: 'edges') anyOne at: 'targetId')
		equals: baseMethod mooseID asString
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testLimitSetsTruncatedFlag [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> otherMethod mooseID asString).
			          (#types -> #( 'invocation' )).
			          (#direction -> 'outgoing').
			          (#depth -> 2).
			          (#limit -> 1) } asDictionary.

	self assert: (result at: 'truncated')
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testLimitTruncates [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> otherMethod mooseID asString).
			          (#types -> #( 'invocation' )).
			          (#direction -> 'outgoing').
			          (#depth -> 2).
			          (#limit -> 1) } asDictionary.

	self assert: (result at: 'edges') size equals: 1.
]

{ #category : 'tests' }
MMCPToolGetRelationshipsTest >> testRaisesWhenEntityIdUnknown [

	self
		should: [
				self callToolWith: {
						(#modelId -> self modelName).
						(#entityId -> 'nope') } asDictionary ]
		raise: Error
]

{ #category : 'private - calling' }
MMCPToolGetRelationshipsTest >> toolClass [

	^ MMCPToolGetRelationships
]
