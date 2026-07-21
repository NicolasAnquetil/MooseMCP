Class {
	#name : 'MMCPRemoveSetCommand',
	#superclass : 'MMCPEntitySetCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'executing' }
MMCPRemoveSetCommand >> execute [

	| setId |
	setId := self request stringArgumentNamed: 'setId'.
	self entitiesForSetId: setId.
	self registry removeSet: setId.
	^ Dictionary new
		  at: 'setId' put: setId;
		  at: 'removed' put: true;
		  yourself
]
