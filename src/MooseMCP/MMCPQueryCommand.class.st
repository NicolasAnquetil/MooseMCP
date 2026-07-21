"
Command that seeds a new entity set for query by delegating to MMCPCommand's model-access helpers.
"
Class {
	#name : 'MMCPQueryCommand',
	#superclass : 'MMCPEntitySetCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPQueryCommand >> execute [

	| modelId entityType filters model candidates filtered |
	modelId := self request stringArgumentNamed: 'modelId'.
	entityType := self request stringArgumentNamed: 'entityType'.
	filters := self request
		           arrayArgumentNamed: 'filters'
		           ifAbsent: [ #(  ) ].
	model := self modelNamed: modelId.
	candidates := self entitiesOfType: entityType in: model.
	filtered := filters isEmpty
		            ifTrue: [ candidates ]
		            ifFalse: [
			            candidates select: [ :e |
				            self entity: e matchesAllFilters: filters ] ].
	^ self registerAndDescribe: filtered
]
