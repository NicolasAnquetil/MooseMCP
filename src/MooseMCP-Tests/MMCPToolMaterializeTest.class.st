Class {
	#name : 'MMCPToolMaterializeTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolMaterializeTest >> testCustomFields [

	| seed result item |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'class').
			        (#filters -> { {
				         (#property -> 'name').
				         (#operator -> 'equals').
				         (#value -> 'BaseClass') } asDictionary }) } asDictionary.

	result := self callToolWith: {
			          (#setId -> (seed at: 'setId')).
			          (#fields -> #( 'name' )) } asDictionary.

	item := (result at: 'items') first.
	self assert: item keys asArray equals: #( 'name' )
]

{ #category : 'tests' }
MMCPToolMaterializeTest >> testRespectsOffsetAndLimit [

	| seed result |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'method') } asDictionary.
	result := self callToolWith: {
			          (#setId -> (seed at: 'setId')).
			          (#offset -> 1).
			          (#limit -> 1) } asDictionary.
	self assert: (result at: 'total') equals: 3.
	self assert: (result at: 'items') size equals: 1
]

{ #category : 'tests' }
MMCPToolMaterializeTest >> testReturnsDefaultFields [

	| seed result item |
	seed := self callTool: MMCPToolQuery with: {
			        (#modelId -> self modelName).
			        (#entityType -> 'class').
			        (#filters -> { {
				         (#property -> 'name').
				         (#operator -> 'equals').
				         (#value -> 'BaseClass') } asDictionary }) } asDictionary.
	result := self callToolWith:
		          { (#setId -> (seed at: 'setId')) } asDictionary.
	self assert: (result at: 'total') equals: 1.
	item := (result at: 'items') first.
	self assert: (item at: 'name') equals: 'BaseClass'.
	self assert: (item at: 'qualifiedName') equals: baseClass mooseName.
	self assert: (item at: 'type') equals: FamixJavaClass name
]

{ #category : 'tests' }
MMCPToolMaterializeTest >> testUnknownSetIdRaisesNotFound [

	self
		should: [
			self callToolWith:
				{ (#setId -> 'set-does-not-exist') } asDictionary ]
		raise: Error
]

{ #category : 'private - calling' }
MMCPToolMaterializeTest >> toolClass [

	^ MMCPToolMaterialize
]
