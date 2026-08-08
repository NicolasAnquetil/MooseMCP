"
Verifies that the five Moose tools are auto-discovered
"
Class {
	#name : 'MooseMCPBuiltInRegistrationTest',
	#superclass : 'MooseMCPWithServerAbstractTest',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'running' }
MooseMCPBuiltInRegistrationTest >> registerMooseMCPTools [

	MMCPTool withAllSubclasses do: [ :c |
		c isAbstract
			ifFalse: [ self toolRegistry registerToolClass: c] ].
]

{ #category : 'running' }
MooseMCPBuiltInRegistrationTest >> setUp [
	super setUp.

	self registerMooseMCPTools
]

{ #category : 'tests' }
MooseMCPBuiltInRegistrationTest >> testMooseToolsAreAutoDiscoveredAsBuiltIn [

	#( 'list_models' 'get_entity' 'get_relationships' 'get_metrics'
	   'render_visualization' 'query' 'filter_set' 'traverse' 'materialize'
	   'remove_set' ) do: [ :toolName |
		self assert: (self toolRegistry includesToolNamed: toolName) ]
]

{ #category : 'tests' }
MooseMCPBuiltInRegistrationTest >> testMooseToolsGroupedTogetherAsMoose [

	| mooseGroup |
	mooseGroup := (self toolRegistry publicToolGroups
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

{ #category : 'running' }
MooseMCPBuiltInRegistrationTest >> toolRegistry [

	^mcpServer toolRegistry
]
