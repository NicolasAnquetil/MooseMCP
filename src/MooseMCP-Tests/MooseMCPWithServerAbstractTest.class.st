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
MooseMCPWithServerAbstractTest >> registerMooseMCPTools [

	MMCPTool withAllSubclasses do: [ :c |
		c isAbstract
			ifFalse: [ self toolRegistry registerToolClass: c] ].
]

{ #category : 'running' }
MooseMCPWithServerAbstractTest >> setUp [
	super setUp.

	mcpServer := MCP new
		monitoringExportDirectory: nil;
		useContentAndStructuredContentToolResponses;
		yourself.
	self registerMooseMCPTools
]

{ #category : 'running' }
MooseMCPWithServerAbstractTest >> toolRegistry [

	^mcpServer toolRegistry
]
