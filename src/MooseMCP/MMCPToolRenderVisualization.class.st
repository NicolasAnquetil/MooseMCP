Class {
	#name : 'MMCPToolRenderVisualization',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'defaults' }
MMCPToolRenderVisualization class >> toolName [

	^ 'render_visualization'
]

{ #category : 'metadata' }
MMCPToolRenderVisualization >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self modelIdSchemaPropertyDescribed: 'The model to visualize.').
				  (self
					   stringEnumSchemaPropertyNamed: 'visualization'
					   description: 'The kind of visualization to render.'
					   values: #( 'dependency_graph' 'inheritance_tree' )).
				  (self
					   schemaPropertyNamed: 'scope'
					   type: 'string'
					   description:
					   'Root entityId to limit the view; omit for the whole model.').
				  (self
					   stringEnumSchemaPropertyNamed: 'format'
					   description: 'Output format for the visualization.'
					   values: #( 'dot' 'mermaid' )
					   default: 'mermaid').
				  (self
					   integerSchemaPropertyNamed: 'maxNodes'
					   description: 'Guardrail against unreadable/huge diagrams.'
					   default: 75) }
		  required: #( 'modelId' 'visualization' )
]

{ #category : 'private - execution' }
MMCPToolRenderVisualization >> commandForRequest: aRequest [

	^ MMCPRenderVisualizationCommand tool: self request: aRequest
]

{ #category : 'metadata' }
MMCPToolRenderVisualization >> description [

	^ 'Render a dependency graph or inheritance tree of a Moose model (or a subset of it) as DOT or Mermaid text.'
]

{ #category : 'private - results' }
MMCPToolRenderVisualization >> successSummaryForResult: result request: aRequest [

	^ 'Rendered ' , (aRequest stringArgumentNamed: 'visualization')
	  , ' as '
	  , (aRequest stringArgumentNamed: 'format' default: 'mermaid') , '.'
]

{ #category : 'metadata' }
MMCPToolRenderVisualization >> title [

	^ 'Render Visualization'
]
