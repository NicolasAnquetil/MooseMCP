Class {
	#name : 'MMCPToolGetMetrics',
	#superclass : 'MMCPTool',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolGetMetrics class >> commandClass [

	^ MMCPGetMetricsCommand
]

{ #category : 'defaults' }
MMCPToolGetMetrics class >> toolName [

	^ 'get_metrics'
]

{ #category : 'metadata' }
MMCPToolGetMetrics >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self modelIdSchemaPropertyDescribed:
					   'The model to compute metrics in.').
				  (self entityIdSchemaPropertyDescribed:
					   'Entity to scope metrics to; omit to scope to the whole model.').
				  (self
					   stringEnumArraySchemaNamed: 'metrics'
					   description:
					   'Metrics to compute; omit for a sensible default set.'
					   itemDescription: 'A metric name.'
					   values:
						   #( 'LOC' 'NOM' 'WMC' 'cyclomaticComplexity'
						      'fanIn' 'fanOut' 'numberOfChildren' 'DIT' )).
				  (self
					   stringEnumSchemaPropertyNamed: 'groupBy'
					   description: 'How to group metric rows.'
					   values: #( 'none' 'package' 'class' )
					   default: 'none') }
		  required: #( 'modelId' )
]

{ #category : 'metadata' }
MMCPToolGetMetrics >> description [

	^ 'Compute software metrics for an entity, or grouped across a whole Moose model.'
]

{ #category : 'private - results' }
MMCPToolGetMetrics >> successSummaryForResult: result request: aRequest [

	^ result size asString , ' metric row(s) computed.'
]

{ #category : 'metadata' }
MMCPToolGetMetrics >> title [

	^ 'Get Metrics'
]
