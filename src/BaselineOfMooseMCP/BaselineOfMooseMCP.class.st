Class {
	#name : 'BaselineOfMooseMCP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMooseMCP',
	#package : 'BaselineOfMooseMCP'
}

{ #category : 'baselines' }
BaselineOfMooseMCP >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec description: 'Moose MCP Server'.
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'packages' }
BaselineOfMooseMCP >> defineDependencies: spec [

	spec
		baseline: 'MCP'
		with: [ 
			spec
				loads: #( Core );
				repository: 'github://Evref-BL/MCP:main/src' ]
]

{ #category : 'packages' }
BaselineOfMooseMCP >> defineGroups: spec [

	spec
		group: 'default' with: #( 'MooseMCP' )
]

{ #category : 'packages' }
BaselineOfMooseMCP >> definePackages: spec [

	spec
		package: 'MooseMCP' with: [ spec requires: #( MCP ) ]
]
