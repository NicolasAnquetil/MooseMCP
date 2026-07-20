"
Command that renders a visualization for render_visualization by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPRenderVisualizationCommand',
	#superclass : 'MCPToolRequestCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPRenderVisualizationCommand >> execute [

	| modelId visualization scope format maxNodes |
	modelId := self request stringArgumentNamed: 'modelId'.
	visualization := self request stringArgumentNamed: 'visualization'.
	scope := self request stringArgumentNamed: 'scope'.
	format := self request
		          stringArgumentNamed: 'format'
		          default: 'mermaid'.
	maxNodes := self request
		            nonNegativeIntegerArgumentNamed: 'maxNodes'
		            default: 75.
	^ MMCPToolServer default
		  renderVisualization: modelId
		  visualization: visualization
		  scope: scope
		  format: format
		  maxNodes: maxNodes
]
