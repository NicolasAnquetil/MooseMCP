"
I verify that MMCPToolServer actually works as an HTTP JSON-RPC server, not just as a set of Smalltalk methods.

I run my own MMCPToolServer instance on a non-default port so I never touch MMCPToolServer default, which is left running for interactive use.
"
Class {
	#name : 'MMCPToolServerTest',
	#superclass : 'TestCase',
	#instVars : [
		'server',
		'testPort',
		'model'
	],
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
MMCPToolServerTest >> setUp [

	super setUp.
	testPort := 4446.
	model := FamixJavaModel named: 'MMCPServerTestModel'.
	MooseModel root add: model.
	server := MMCPToolServer new.
	server port: testPort.
	server start
]

{ #category : 'running' }
MMCPToolServerTest >> tearDown [

	server ifNotNil: [ server stop ].
	model ifNotNil: [ model remove ].
	super tearDown
]

{ #category : 'tests' }
MMCPToolServerTest >> testServerRespondsToJSONRPCListModels [

	| httpResponse directResult |
	httpResponse := ZnClient new
		                url: 'http://localhost:' , testPort asString , '/';
		                entity: (ZnEntity json:
					                 '{"jsonrpc":"2.0","id":1,"method":"list:models","params":[true]}');
		                post;
		                contents.
	directResult := MMCPToolServer default listModels: true.
	self assert: (httpResponse includesSubstring: '"result"').
	self deny: (httpResponse includesSubstring: '"error"').
	self assert: (httpResponse includesSubstring: model name).
	self assert:
		(directResult anySatisfy: [ :e | (e at: 'modelId') = model name ])
]
