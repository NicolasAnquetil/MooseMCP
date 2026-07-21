Class {
	#name : 'MMCPToolQueryTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolQueryTest >> testAppliesFiltersWhenSeeding [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityType -> 'class').
			          (#filters -> { {
				           (#property -> 'name').
				           (#operator -> 'equals').
				           (#value -> 'BaseClass') } asDictionary }) }
			          asDictionary.
	self assert: (result at: 'count') equals: 1.
	self assert:
		((result at: 'preview') anyOne includesSubstring: 'BaseClass')
]

{ #category : 'tests' }
MMCPToolQueryTest >> testSeedsSetFromEntityType [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityType -> 'class') } asDictionary.
	self assert: (result at: 'count') equals: 4.
	self assert: (result at: 'setId') notNil
]

{ #category : 'private - calling' }
MMCPToolQueryTest >> toolClass [

	^ MMCPToolQuery
]
