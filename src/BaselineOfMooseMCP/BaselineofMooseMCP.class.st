Class {
	#name : 'BaselineofMooseMCP',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMooseMCP',
	#package : 'BaselineOfMooseMCP'
}

{ #category : 'baselines' }
BaselineofMooseMCP >> baseline: spec [

	<baseline>
	spec for: #common do: [
		spec description: 'Moose MCP Server'.
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec ]
]

{ #category : 'packages' }
BaselineofMooseMCP >> defineDependencies: spec [

	spec
		baseline: 'JRPC'
		with: [ 
			spec
				loads: #( Deployment );
				repository: 'https://github.com/juliendelplanque/JRPC' ]
]

{ #category : 'packages' }
BaselineofMooseMCP >> defineGroups: spec [

	spec
		group: 'default' with: #( 'MooseMCP' )
]

{ #category : 'packages' }
BaselineofMooseMCP >> definePackages: spec [

	spec
		package: 'MooseMCP' with: [ spec requires: #( JRPC ) ]
]
