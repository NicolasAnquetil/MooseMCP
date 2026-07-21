Class {
	#name : 'MMCPToolTraverseTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolTraverseTest >> testDepthExpandsTransitively [
	"otherMethod invokes subMethod (deepInvocationEdge); subMethod invokes baseMethod (invocationEdge).
	invokingMethods from baseMethod at depth 1 reaches subMethod only; at depth 2 also reaches otherMethod."

	| seed result1 result2 |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'method').
			        (#filters -> { {
				         (#property -> 'name').
				         (#operator -> 'equals').
				         (#value -> 'baseMethod') } asDictionary }) } asDictionary.
	result1 := self callToolWith: {
			           (#setId -> (seed at: 'setId')).
			           (#relationship -> 'invokingMethods').
			           (#depth -> 1) } asDictionary.
	self assert: (result1 at: 'count') equals: 1.
	result2 := self callToolWith: {
			           (#setId -> (seed at: 'setId')).
			           (#relationship -> 'invokingMethods').
			           (#depth -> 2) } asDictionary.
	self assert: (result2 at: 'count') equals: 2
]

{ #category : 'tests' }
MMCPToolTraverseTest >> testFollowsMethodsRelationship [

	| seed result |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'class').
			        (#filters -> { {
				         (#property -> 'name').
				         (#operator -> 'equals').
				         (#value -> 'BaseClass') } asDictionary }) } asDictionary.
	result := self callToolWith: {
			          (#setId -> (seed at: 'setId')).
			          (#relationship -> 'methods') } asDictionary.
	self assert: (result at: 'count') equals: 1.
	self assert:
		((result at: 'preview') first includesSubstring: 'baseMethod')
]

{ #category : 'tests' }
MMCPToolTraverseTest >> testFollowsSubclassesRelationship [

	| seed result |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'class').
			        (#filters -> { {
				         (#property -> 'name').
				         (#operator -> 'equals').
				         (#value -> 'BaseClass') } asDictionary }) } asDictionary.
	result := self callToolWith: {
			          (#setId -> (seed at: 'setId')).
			          (#relationship -> 'subclasses') } asDictionary.
	self assert: (result at: 'count') equals: 1.
	self assert:
		((result at: 'preview') first includesSubstring: 'SubClass')
]

{ #category : 'tests' }
MMCPToolTraverseTest >> testUnknownSetIdRaisesNotFound [

	self
		should: [
				self callToolWith: {
						(#setId -> 'set-does-not-exist').
						(#relationship -> 'methods') } asDictionary ]
		raise: Error
]

{ #category : 'private - calling' }
MMCPToolTraverseTest >> toolClass [

	^ MMCPToolTraverse
]
