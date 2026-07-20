"
Command that lists loaded Moose models for list_models by delegating to MMCPToolServer.
"
Class {
	#name : 'MMCPListModelsCommand',
	#superclass : 'MMCPCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPListModelsCommand >> execute [

	| includeStats |
	includeStats := self request
		                booleanArgumentNamed: 'includeStats'
		                default: true.
	^ (MooseModel root allModels collect: [ :m |
		   self describeModel: m includeStats: includeStats ]) asArray
]
