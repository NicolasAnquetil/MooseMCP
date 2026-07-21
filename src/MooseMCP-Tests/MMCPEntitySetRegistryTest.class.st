Class {
	#name : 'MMCPEntitySetRegistryTest',
	#superclass : 'TestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testEntitiesForReturnsRegisteredCollection [

	| registry id |
	registry := MMCPEntitySetRegistry new.
	id := registry registerSet: #( 1 2 3 ) asOrderedCollection.
	self
		assert: (registry entitiesFor: id)
		equals: #( 1 2 3 ) asOrderedCollection
]

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testEntitiesForUnknownIdRaisesEntitySetNotFound [

	| registry |
	registry := MMCPEntitySetRegistry new.
	self
		should: [ registry entitiesFor: 'set-nope' ]
		raise: MCPCommandError
		withExceptionDo: [ :ex |
		self assert: ex errorCode equals: #EntitySetNotFound ]
]

{ #category : 'tests' }
MMCPEntitySetRegistryTest >> testRegisterSetAssignsSequentialIds [

	| registry id1 id2 |
	registry := MMCPEntitySetRegistry new.
	id1 := registry registerSet: #( 1 2 3 ) asOrderedCollection.
	id2 := registry registerSet: #( 4 5 ) asOrderedCollection.
	self assert: id1 equals: 'set-1'.
	self assert: id2 equals: 'set-2'.
	self assert: registry size equals: 2
]
