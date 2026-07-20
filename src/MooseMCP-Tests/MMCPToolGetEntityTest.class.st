Class {
	#name : 'MMCPToolGetEntityTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolGetEntityTest >> testExactMatchExcludesPartialNames [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#query -> 'Base').
			          (#exactMatch -> true) } asDictionary.
	self assert: result isEmpty
]

{ #category : 'tests' }
MMCPToolGetEntityTest >> testFiltersByEntityType [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#query -> '').
			          (#entityType -> 'class') } asDictionary.
	self assert: result size equals: 4.
	self assert:
		(result allSatisfy: [ :e | (e at: 'type') = FamixJavaClass name ])
]

{ #category : 'tests' }
MMCPToolGetEntityTest >> testFindsEntitiesBySubstringQueryCaseInsensitive [

	| result names |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#query -> 'baseclass') } asDictionary.
	names := result collect: [ :e | e at: 'name' ].
	self assert: (names includes: 'BaseClass')
]

{ #category : 'tests' }
MMCPToolGetEntityTest >> testFindsEntityByExactId [

	| result entry |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#entityId -> subClass mooseID asString) } asDictionary.
	self assert: result size equals: 1.
	entry := result first.
	self assert: (entry at: 'name') equals: 'SubClass'.
	self assert: (entry at: 'id') equals: subClass mooseID asString
]

{ #category : 'tests' }
MMCPToolGetEntityTest >> testRaisesWhenModelIdUnknown [

	self
		should: [
				self callToolWith: {
						(#modelId -> 'NoSuchModel').
						(#query -> '') } asDictionary ]
		raise: Error
]

{ #category : 'tests' }
MMCPToolGetEntityTest >> testRespectsLimit [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#query -> '').
			          (#entityType -> 'class').
			          (#limit -> 2) } asDictionary.
	self assert: result size equals: 2
]

{ #category : 'private - calling' }
MMCPToolGetEntityTest >> toolClass [

	^ MMCPToolGetEntity
]
