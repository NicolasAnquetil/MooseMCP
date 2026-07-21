Class {
	#name : 'MMCPToolRemoveSetTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolRemoveSetTest >> testRemovesExistingSet [

	| seed result |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'class') } asDictionary.
	result := self callToolWith:
		          { (#setId -> (seed at: 'setId')) } asDictionary.
	self assert: (result at: 'removed') equals: true.
	self assert: (result at: 'setId') equals: (seed at: 'setId').
	self
		should: [
				self
					callTool: MMCPToolMaterialize
					with: { (#setId -> (seed at: 'setId')) } asDictionary ]
		raise: Error
]

{ #category : 'tests' }
MMCPToolRemoveSetTest >> testUnknownSetIdRaisesNotFound [

	self
		should: [
			self callToolWith:
				{ (#setId -> 'set-does-not-exist') } asDictionary ]
		raise: Error
]

{ #category : 'private - calling' }
MMCPToolRemoveSetTest >> toolClass [

	^ MMCPToolRemoveSet
]
