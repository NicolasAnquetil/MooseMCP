Class {
	#name : 'MMCPToolFilterSetTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolFilterSetTest >> testNarrowsExistingSet [

	| seed result |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'class') } asDictionary.
	result := self callToolWith: {
			          (#setId -> (seed at: 'setId')).
			          (#filters -> { {
				           (#property -> 'name').
				           (#operator -> 'equals').
				           (#value -> 'BaseClass') } asDictionary }) }
			          asDictionary.
	self assert: (result at: 'count') equals: 1
]

{ #category : 'tests' }
MMCPToolFilterSetTest >> testUnknownSetIdRaisesNotFound [

	self
		should: [
				self callToolWith: {
						(#setId -> 'set-does-not-exist').
						(#filters -> #(  )) } asDictionary ]
		raise: Error
]

{ #category : 'private - calling' }
MMCPToolFilterSetTest >> toolClass [

	^ MMCPToolFilterSet
]
