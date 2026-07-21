"
Verifies that the five Moose tools are auto-discovered as built-in by a freshly constructed MCPToolRegistry (via MCPTool class>>concreteSubclasses/isBuiltIn), without any explicit registerToolClass: call.
"
Class {
	#name : 'MooseMCPBuiltInRegistrationTest',
	#superclass : 'MCPTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MooseMCPBuiltInRegistrationTest >> testMooseToolsAreAutoDiscoveredAsBuiltIn [

	| registry |
	registry := self mcpWithoutObservabilityExport toolRegistry.
	#( 'list_models' 'get_entity' 'get_relationships' 'get_metrics'
	   'render_visualization' 'query' 'filter_set' 'traverse' 'materialize'
	   'remove_set' ) do: [ :toolName |
		self assert: (registry includesToolNamed: toolName) ]
]

{ #category : 'tests' }
MooseMCPBuiltInRegistrationTest >> testMooseToolsGroupedTogetherAsMoose [

	| registry mooseGroup |
	registry := self mcpWithoutObservabilityExport toolRegistry.
	mooseGroup := (registry publicToolGroups
		               detect: [ :each | each key = 'moose' ]
		               ifNone: [ self fail ]) value.
	self assert: mooseGroup asSet equals: {
			MMCPToolListModels.
			MMCPToolGetEntity.
			MMCPToolGetRelationships.
			MMCPToolGetMetrics.
			MMCPToolRenderVisualization.
			MMCPToolQuery.
			MMCPToolFilterSet.
			MMCPToolTraverse.
			MMCPToolMaterialize.
			MMCPToolRemoveSet } asSet
]
