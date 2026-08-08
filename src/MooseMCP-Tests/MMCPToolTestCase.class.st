"
I am the abstract base for MooseMCP tool tests.

I compose a `MMCPToolTestFixture` (see `fixture`) — a small, deterministic FamixJavaModel scenario registered with `MooseModel root` so `MMCPCommand`'s name-based model lookup finds it exactly like a real imported model. Subclasses reach into fixture entities via `fixture baseClass`, `fixture subClass`, etc. (inherited ivar, not an accessor call). Subclasses set `toolClass` and use `callToolWith:` to exercise that tool's `executeWithRequest:` directly, since the MMCPTool* classes are not registered in `MCPToolRegistry` and cannot be reached through the normal tool-call catalog.
"
Class {
	#name : 'MMCPToolTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'fixture'
	],
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'testing' }
MMCPToolTestCase class >> isAbstract [

	^ self = MMCPToolTestCase or: [ super isAbstract ]
]

{ #category : 'private - calling' }
MMCPToolTestCase >> callTool: aToolClass with: someArguments [

	| tool request |
	tool := aToolClass new.
	request := tool requestFromToolCallArguments: someArguments.
	^ (tool executeWithRequest: request) structuredContent at: #data
]

{ #category : 'private - calling' }
MMCPToolTestCase >> callToolWith: someArguments [

	^ self callTool: self toolClass with: someArguments
]

{ #category : 'private - fixture' }
MMCPToolTestCase >> modelName [

	^ fixture modelName
]

{ #category : 'running' }
MMCPToolTestCase >> setUp [

	super setUp.
	fixture := MMCPToolTestFixture buildLabeled: self class name
]

{ #category : 'running' }
MMCPToolTestCase >> tearDown [

	fixture remove.
	super tearDown
]

{ #category : 'private - calling' }
MMCPToolTestCase >> toolClass [

	self subclassResponsibility
]
