Class {
	#name : 'MMCPEntitySetRegistryTest',
	#superclass : 'TestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testClearRemovesAllRegisteredSets [

	| registry id |
	registry := MMCPEntitySetRegistry new.
	id := registry registerSet: #( a b c ) asOrderedCollection.
	self assert: registry size equals: 1.

	registry clear.

	self assert: registry size equals: 0.
	self
		should: [ registry entitiesFor: id ]
		raise: MCPCommandError
		withExceptionDo: [ :ex |
		self assert: ex errorCode equals: #EntitySetNotFound ]
]

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testEntitiesForReturnsRegisteredCollection [

	| registry id |
	registry := MMCPEntitySetRegistry new.
	id := registry registerSet: #( a b c ) asOrderedCollection.

	self
		assert: (registry entitiesFor: id)
		equals: #( a b c ) asOrderedCollection
]

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testEntitiesForUnknownIdRaisesEntitySetNotFound [

	| registry |
	registry := MMCPEntitySetRegistry new.

	self
		should: [ registry entitiesFor: 'set-nope' ]
		raise: MCPCommandError
		withExceptionDo: [ :ex | self assert: ex errorCode equals: #EntitySetNotFound ]
]

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testRegisterSetAssignsSequentialIds [

	| registry id1 id2 |
	registry := MMCPEntitySetRegistry new.
	id1 := registry registerSet: #( a b c ) asOrderedCollection.
	id2 := registry registerSet: #( d e ) asOrderedCollection.

	self assert: registry size equals: 2.
	self assert: id1 equals: 'set-1'.
	self assert: id2 equals: 'set-2'.
]

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testRemoveSetRemovesOnlyThatEntry [

	| registry id1 id2 |
	registry := MMCPEntitySetRegistry new.
	id1 := registry registerSet: #( 1 2 3 ) asOrderedCollection.
	id2 := registry registerSet: #( 4 5 ) asOrderedCollection.
	self assert: registry size equals: 2.

	registry removeSet: id1.

	self assert: registry size equals: 1.
	self
		should: [ registry entitiesFor: id1 ]
		raise: MCPCommandError
		withExceptionDo: [ :ex | self assert: ex errorCode equals: #EntitySetNotFound ].
	self
		assert: (registry entitiesFor: id2)
		equals: #( 4 5 ) asOrderedCollection
]
