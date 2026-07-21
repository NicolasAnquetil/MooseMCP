Class {
	#name : 'MMCPToolFilterSetTest',
	#superclass : 'MMCPToolOnResultSetTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolFilterSetTest >> testNarrowsExistingSet [

	| result |
	result := self callToolWith: {
			          (#setId -> allClassesSetId).
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
