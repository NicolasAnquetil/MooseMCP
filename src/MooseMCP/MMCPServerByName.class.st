Class {
	#name : 'MMCPServerByName',
	#superclass : 'MMCPServerFormatter',
	#category : 'MooseMCP',
	#package : 'MooseMCP'
}

{ #category : 'utilities' }
MMCPServerByName >> getEntity: aName ifAbsent: aBlock [

	^mooseModel entityNamed: aName ifAbsent: [ aBlock value ]
]

{ #category : 'utilities' }
MMCPServerByName >> returnMooseEntity: anEntitity [

	^anEntitity mooseName
]
