Class {
	#name : 'MooseMCPWithServerAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'mcpServer'
	],
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
MooseMCPWithServerAbstractTest >> setUp [
	super setUp.

	mcpServer := MCP new
		monitoringExportDirectory: nil;
		useContentAndStructuredContentToolResponses;
		yourself
]

{ #category : 'running' }
MooseMCPWithServerAbstractTest >> toolRegistry [

	^mcpServer toolRegistry
]
