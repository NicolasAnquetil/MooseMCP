Class {
	#name : 'MMCPToolRenderVisualizationTest',
	#superclass : 'MMCPToolTestCase',
	#category : 'MooseMCP-Tests-Tools',
	#package : 'MooseMCP-Tests',
	#tag : 'Tools'
}

{ #category : 'tests' }
MMCPToolRenderVisualizationTest >> testMaxNodesGuardrailLimitsOutput [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#visualization -> 'dependency_graph').
			          (#format -> 'mermaid').
			          (#maxNodes -> 1) } asDictionary.
	self deny: (result includesSubstring: '-->')
]

{ #category : 'tests' }
MMCPToolRenderVisualizationTest >> testRendersDependencyGraphAsMermaid [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#visualization -> 'dependency_graph').
			          (#format -> 'mermaid') } asDictionary.
	self assert: (result beginsWith: 'graph TD').
	self assert: (result includesSubstring:
			 package2 mooseID asString , ' --> ' , subMethod mooseID asString)
]

{ #category : 'tests' }
MMCPToolRenderVisualizationTest >> testRendersInheritanceTreeAsDot [

	| result |
	result := self callToolWith: {
			          (#modelId -> self modelName).
			          (#visualization -> 'inheritance_tree').
			          (#format -> 'dot') } asDictionary.
	self
		assert: result
		equals:
			'digraph G {' , String lf , '  "' , subClass mooseID asString
			, '" -> "' , baseClass mooseID asString , '";' , String lf , '}'
			, String lf
]

{ #category : 'tests' }
MMCPToolRenderVisualizationTest >> testSchemaRejectsUnsupportedFormat [
	"format is enum-restricted to dot/mermaid in the tool's input schema, so an invalid
	format is rejected during request validation, before executeWithRequest: runs."

	self
		should: [
				self callToolWith: {
						(#modelId -> self modelName).
						(#visualization -> 'dependency_graph').
						(#format -> 'png') } asDictionary ]
		raise: Error
]

{ #category : 'tests' }
MMCPToolRenderVisualizationTest >> testSchemaRejectsUnsupportedVisualizationKind [
	"visualization is enum-restricted to dependency_graph/inheritance_tree, so an
	unsupported kind is rejected during request validation, before executeWithRequest: runs."

	self
		should: [
				self callToolWith: {
						(#modelId -> self modelName).
						(#visualization -> 'bogus') } asDictionary ]
		raise: Error
]

{ #category : 'tests' }
MMCPToolRenderVisualizationTest >> testServerRejectsPngFormatDirectly [
	"Building the command directly with an unvalidated request (bypassing schema validation)
	exercises the command's own explicit png/svg guard rather than the schema-level enum
	rejection above."

	| tool request command |
	tool := self toolClass new.
	request := MCPToolRequest new
		           tool: tool;
		           arguments: (Dictionary new
				            at: 'modelId' put: self modelName;
				            at: 'visualization' put: 'dependency_graph';
				            at: 'format' put: 'png';
				            at: 'maxNodes' put: 10;
				            yourself);
		           yourself.
	command := MMCPRenderVisualizationCommand tool: tool request: request.
	self should: [ command execute ] raise: Error
]

{ #category : 'private - calling' }
MMCPToolRenderVisualizationTest >> toolClass [

	^ MMCPToolRenderVisualization
]
