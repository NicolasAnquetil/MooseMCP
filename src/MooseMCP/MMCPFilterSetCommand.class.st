"
Command that narrows an existing entity set for filter_set.
"
Class {
	#name : 'MMCPFilterSetCommand',
	#superclass : 'MMCPEntitySetCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPFilterSetCommand >> execute [

	| setId filters entities |
	setId := self request stringArgumentNamed: 'setId'.
	filters := self request
		           arrayArgumentNamed: 'filters'
		           ifAbsent: [ #(  ) ].
	entities := self entitiesForSetId: setId.
	^ self registerAndDescribe:
		  (entities select: [ :e |
			   self entity: e matchesAllFilters: filters ])
]
