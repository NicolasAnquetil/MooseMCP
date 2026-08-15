Class {
	#name : 'MMCPModelEntityCommand',
	#superclass : 'MMCPCommand',
	#category : 'MooseMCP-Commands',
	#package : 'MooseMCP',
	#tag : 'Commands'
}

{ #category : 'testing' }
MMCPModelEntityCommand class >> isAbstract [

	^ self == MMCPModelEntityCommand

]

{ #category : 'executing' }
MMCPModelEntityCommand >> execute [

	| entityId model entity |

	model := self modelNamed: (self request stringArgumentNamed: 'modelId').
	entityId := self request stringArgumentNamed: 'entityId' default: nil.
	entity := (entityId isNil or: [ entityId isEmpty ])
			  ifTrue: [ nil ]
			  ifFalse: [ self entityWithId: entityId in: model ].

	^ self executeOn: model entity: entity
]

{ #category : 'accessing' }
MMCPModelEntityCommand >> executeOn: aModel entity: anEntityOrNil [

	^ self subclassResponsibility
]
