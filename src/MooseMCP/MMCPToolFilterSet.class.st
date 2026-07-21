Class {
	#name : 'MMCPToolFilterSet',
	#superclass : 'MMCPToolOnResultSet',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolFilterSet class >> commandClass [

	^ MMCPFilterSetCommand
]

{ #category : 'defaults' }
MMCPToolFilterSet class >> toolName [

	^ 'filter_set'
]

{ #category : 'metadata' }
MMCPToolFilterSet >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties: {
				  (self setIdSchemaPropertyDescribed: 'The entity set to narrow.').
				  self filtersSchemaProperty }
		  required: #( 'setId' 'filters' )
]

{ #category : 'metadata' }
MMCPToolFilterSet >> description [

	^ 'Apply predicates to an existing entity set, producing a new set.'
]

{ #category : 'private - results' }
MMCPToolFilterSet >> successSummaryForResult: result request: aRequest [

	^ (result at: 'count') asString , ' entities in new set '
	  , (result at: 'setId') , '.'
]

{ #category : 'metadata' }
MMCPToolFilterSet >> title [

	^ 'Filter Set'
]
