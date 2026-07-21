Class {
	#name : 'MMCPToolRemoveSet',
	#superclass : 'MMCPToolOnResultSet',
	#category : 'MooseMCP-Tools',
	#package : 'MooseMCP',
	#tag : 'Tools'
}

{ #category : 'metadata' }
MMCPToolRemoveSet class >> commandClass [

	^ MMCPRemoveSetCommand
]

{ #category : 'defaults' }
MMCPToolRemoveSet class >> toolName [

	^ 'remove_set'
]

{ #category : 'metadata' }
MMCPToolRemoveSet >> buildInputSchema [

	^ self
		  objectInputSchemaWithProperties:
		  { (self setIdSchemaPropertyDescribed: 'The entity set to remove.') }
		  required: #( 'setId' )
]

{ #category : 'metadata' }
MMCPToolRemoveSet >> description [

	^ 'Remove an entity set from the registry, freeing its handle.'
]

{ #category : 'private - results' }
MMCPToolRemoveSet >> successSummaryForResult: result request: aRequest [

	^ 'Removed set ' , (result at: 'setId') , '.'
]

{ #category : 'metadata' }
MMCPToolRemoveSet >> title [

	^ 'Remove Set'
]
