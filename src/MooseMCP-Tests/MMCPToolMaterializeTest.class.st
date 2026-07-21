Class {
	#name : 'MMCPToolMaterializeTest',
	#superclass : 'MMCPToolOnResultSetTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolMaterializeTest >> testCustomFields [

	| result item |
	result := self callToolWith: {
			          (#setId -> baseClassSetId).
			          (#fields -> #( 'name' )) } asDictionary.

	item := (result at: 'items') first.
	self assert: item keys asArray equals: #( 'name' )
]

{ #category : 'tests' }
MMCPToolMaterializeTest >> testRespectsLimit [

	| result |
	result := self callToolWith: {
			          (#setId -> allMethodsSetId).
			          (#limit -> 1) } asDictionary.

	self assert: (result at: 'total') equals: 3.
	self assert: (result at: 'items') size equals: 1
]

{ #category : 'tests' }
MMCPToolMaterializeTest >> testRespectsOffset [

	| full atOffset1 atOffset2 |
	full := self callToolWith: {
			        (#setId -> allMethodsSetId).
			        (#limit -> 3) } asDictionary.

	self assert: (full at: 'items') size equals: 3.

	atOffset1 := self callToolWith: {
			             (#setId -> allMethodsSetId).
			             (#offset -> 1).
			             (#limit -> 1) } asDictionary.
	self
		assert: (atOffset1 at: 'items') first
		equals: (full at: 'items') second.

	atOffset2 := self callToolWith: {
			             (#setId -> allMethodsSetId).
			             (#offset -> 2).
			             (#limit -> 1) } asDictionary.
	self
		assert: (atOffset2 at: 'items') first
		equals: (full at: 'items') third
]

{ #category : 'tests' }
MMCPToolMaterializeTest >> testReturnsDefaultFields [

	| result item |
	result := self callToolWith:
		          { (#setId -> baseClassSetId) } asDictionary.

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
