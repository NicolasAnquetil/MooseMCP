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
		baseline: 'JRPC'
		with: [ 
			spec
				loads: #( Deployment );
				repository: 'https://github.com/juliendelplanque/JRPC' ]
]

{ #category : 'packages' }
BaselineOfMooseMCP >> defineGroups: spec [

	spec
		group: 'default' with: #( 'MooseMCP' )
]

{ #category : 'packages' }
BaselineOfMooseMCP >> definePackages: spec [

	spec
		package: 'MooseMCP' with: [ spec requires: #( JRPC ) ]
]
