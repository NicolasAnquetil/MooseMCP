"
I verify that the Moose tools remain correctly wired end-to-end through the real MCP dispatch path (MCP>>rpcToolCall:withParams:, i.e. registry lookup + MCPTool>>commandForRequest: + the concrete MMCPCommand subclass), not just through the direct in-image callToolWith: path the other MMCPTool*Test classes use.
"
Class {
	#name : 'MooseMCPToolDispatchTest',
	#superclass : 'MooseMCPWithServerAbstractTest',
	#instVars : [
		'fixture'
	],
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'private - calling' }
MooseMCPToolDispatchTest >> rpcCall: aToolName with: someArguments [

	| result structuredContent |

	result := mcpServer rpcToolCall: 'tool_call' withParams: {
			          (#toolName -> aToolName).
			          (#arguments -> someArguments) } asDictionary.
	structuredContent := result at: #structuredContent.
	self
		deny: ((structuredContent at: #isError ifAbsent: [ false ]) or: [
				 (structuredContent at: #status ifAbsent: [ 'ok' ]) = 'error' ])
		description: structuredContent printString.
	^ structuredContent at: #data
]

{ #category : 'running' }
MooseMCPToolDispatchTest >> setUp [

	super setUp.
	fixture := MMCPToolTestFixture buildLabeled: self class name
]

{ #category : 'running' }
MooseMCPToolDispatchTest >> tearDown [

	fixture remove.
	super tearDown
]

{ #category : 'tests' }
MooseMCPToolDispatchTest >> testDispatchesGetEntityThroughRegistry [

	| data entry |
	data := self rpcCall: 'get_entity' with: {
			        (#modelId -> fixture modelName).
			        (#entityId -> fixture baseClass mooseID asString) }
			        asDictionary.
	self assert: data size equals: 1.
	entry := data anyOne.
	self assert: (entry at: 'name') equals: 'BaseClass'.
	self
		assert: (entry at: 'id')
		equals: fixture baseClass mooseID asString
]

{ #category : 'tests' }
MooseMCPToolDispatchTest >> testDispatchesListModelsThroughRegistry [

	| data entry |
	data := self
		        rpcCall: 'list_models'
		        with: { (#includeStats -> true) } asDictionary.
	entry := data detect: [ :each |
		         (each at: 'modelId') = fixture modelName ].
	self assert: (entry at: 'numClasses') equals: 4.
	self assert: (entry at: 'numMethods') equals: 3.
	self assert: (entry at: 'numPackages') equals: 2
]

{ #category : 'tests' }
MooseMCPToolDispatchTest >> testDispatchesRenderVisualizationThroughRegistry [

	| mermaid |
	mermaid := self rpcCall: 'render_visualization' with: {
			           (#modelId -> fixture modelName).
			           (#visualization -> 'inheritance_tree').
			           (#format -> 'mermaid') } asDictionary.
	self assert: (mermaid beginsWith: 'graph TD').
	self assert: (mermaid includesSubstring:
			 fixture subClass mooseID asString , ' --> '
			 , fixture baseClass mooseID asString)
]
