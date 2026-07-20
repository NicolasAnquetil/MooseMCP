"
I verify that the Moose tools remain correctly wired end-to-end through the real MCP dispatch path (MCP>>rpcToolCall:withParams:, i.e. registry lookup + MCPTool>>commandForRequest: + the concrete MMCPCommand subclass), not just through the direct in-image callToolWith: path the other MMCPTool*Test classes use.
"
Class {
	#name : 'MooseMCPToolDispatchTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}
